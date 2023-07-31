from flask import Flask, render_template, request, session, redirect
import psycopg2
import hashlib
import jinja2.ext
import math
from math import sqrt
from decimal import Decimal, DivisionByZero
import decimal
import logging
import pandas as pd
import numpy as np

app = Flask(__name__)
app.secret_key = 'andasiapa'
app.jinja_env.add_extension(jinja2.ext.loopcontrols)

# Koneksi ke database
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="db_seleksi",
    user="shairul",
    password="12345678"
)
cur = conn.cursor()


# Baris Function (start) ==============================

# Function untuk mengenkripsi password menggunakan SHA256
def hash_password(password):
    sha256_hash = hashlib.sha256()
    sha256_hash.update(password.encode('utf-8'))
    return sha256_hash.hexdigest()

# Function lengkapi data user
def lengkapi_data_user(nisn, user_id, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah):
    # Masukkan data ke tabel tbl_pemain
    cur.execute("INSERT INTO tbl_pemain (nisn, id_user, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah) VALUES (%s, %s, %s, %s, %s, %s)", (nisn, user_id, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah))
    conn.commit()

    # Perbarui status data completed pada tabel tbl_users
    cur.execute("UPDATE tbl_users SET user_data_completed = TRUE WHERE id_user = %s", (user_id,))
    conn.commit()


# Function untuk melengkapi data admin
def lengkapi_data_admin(user_id, nama_admin, tgl_lahir_admin, jabatan):
    # Masukkan data ke tabel tbl_admin
    cur.execute("INSERT INTO tbl_admin (id_user, nama_admin, tgl_lahir_admin, jabatan) VALUES (%s, %s, %s, %s)", (user_id, nama_admin, tgl_lahir_admin, jabatan))
    conn.commit()

    # Perbarui status data completed pada tabel tbl_users
    cur.execute("UPDATE tbl_users SET admin_data_completed = TRUE WHERE id_user = %s", (user_id,))
    conn.commit()


#Fungsi hitung skor moora
def hitung_skor_moora(nisn, posisi_pemain, cur, conn):
    # Mendapatkan data nilai kriteria berdasarkan nisn pemain dan posisi_pemain dari tabel "tbl_nilai_kriteria"
    cur.execute("SELECT nk.id_kriteria, nk.nilai, k.bobot, k.tipe FROM tbl_nilai_kriteria nk JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria WHERE k.posisi = %s", (posisi_pemain,))
    data_nilai_kriteria = cur.fetchall()

    print("")
    print("dnk")
    print(data_nilai_kriteria)

    if not data_nilai_kriteria:
        # Jika tidak ada data nilai kriteria untuk pemain ini, berikan skor default dan langsung simpan ke dalam tabel "tbl_skor_moora"
        default_skor = Decimal(0.0000)  # Atur skor default sesuai kebutuhan
        cur.execute("INSERT INTO tbl_skor_moora (nisn, skor) VALUES (%s, %s) ON CONFLICT (nisn) DO UPDATE SET skor = EXCLUDED.skor", (nisn, default_skor))
        conn.commit()
        return

    # Ubah data nilai kriteria menjadi list nilai
    nilai_per_kriteria = {id_kriteria: [] for id_kriteria, _, _, _ in data_nilai_kriteria}
    tipe_kriteria = {id_kriteria: tipe for id_kriteria, _, _, tipe in data_nilai_kriteria}
    bobot_kriteria = {id_kriteria: bobot for id_kriteria, _, bobot, _ in data_nilai_kriteria}  # Perbaiki penggunaan kunci

    for id_kriteria, nilai, _, _ in data_nilai_kriteria:  # Jangan masukkan variabel yang tidak digunakan dengan _
        nilai_per_kriteria[id_kriteria].append(Decimal(nilai))

    print("")
    print("npk")
    print(nilai_per_kriteria)

    # Mendapatkan data bobot kriteria berdasarkan posisi pemain dari tabel "tbl_kriteria"
    cur.execute("SELECT bobot, tipe FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
    data_kriteria = cur.fetchall()
    
    print("")
    print("dk")
    print(data_kriteria)

    print("")
    print("bobot")
    print(bobot_kriteria)

    # Memisahkan nilai kriteria berdasarkan tipe 'cost' dan 'benefit'
    benefit_values = [sum(nilai_per_kriteria[id_kriteria]) for id_kriteria in nilai_per_kriteria if tipe_kriteria[id_kriteria] == 'benefit']
    cost_values = [sum(nilai_per_kriteria[id_kriteria]) for id_kriteria in nilai_per_kriteria if tipe_kriteria[id_kriteria] == 'cost']

    print("")
    print("benefit_values")
    print(benefit_values)
    print("")
    print("cost_values")
    print(cost_values)

    # Menghitung total kuadrat kriteria untuk pemain berdasarkan satu matriks nilai kriteria
    jumlah_kuadrat_kriteria = {id_kriteria: sum(nilai ** 2 for nilai in nilai_per_kriteria[id_kriteria]) for id_kriteria in nilai_per_kriteria}

    print("")
    print("jkk")
    print(jumlah_kuadrat_kriteria)

    # Akarkan Hasil Penjumlahan untuk mendapatkan akar_penjumlahan
    akar_penjumlahan = {id_kriteria: Decimal(sqrt(jumlah)) for id_kriteria, jumlah in jumlah_kuadrat_kriteria.items()}  # Convert akar_penjumlahan to Decimal

    print("")
    print("ap")
    print(akar_penjumlahan)

    # Menghitung normalisasi matriks berdasarkan nilai terakhir dari nilai_per_kriteria dan akar_penjumlahan
    normalisasi_matriks = {}

    for id_kriteria, nilai_kriteria in nilai_per_kriteria.items():
        # Mengambil nilai terakhir dari list nilai_kriteria
        nilai_terakhir = nilai_kriteria[-1]

    # Mengambil nilai akar_penjumlahan berdasarkan id_kriteria
    akar_penjumlahan_kriteria = akar_penjumlahan[id_kriteria]

    # Menghitung normalisasi matriks berdasarkan nilai terakhir dan akar_penjumlahan
    normalisasi_matriks[id_kriteria] = nilai_terakhir / akar_penjumlahan_kriteria

    print("")
    print("normalisasi matriks")
    print(normalisasi_matriks)

    # Normalisasi terbobot kriteria (nilai awal / akar penjumlahan * bobot kriteria)
    normalisasi_terbobot_kriteria = {
        id_kriteria: [(nilai / akar_penjumlahan[id_kriteria]) * bobot_kriteria[id_kriteria] for nilai in nilai_per_kriteria[id_kriteria]]
        for id_kriteria in nilai_per_kriteria
    }  
    print("")
    print("ntbk")
    print(normalisasi_terbobot_kriteria)

    # Menghitung nilai C (a - b) berdasarkan tipe kriteria
    a_values = sum(normalisasi_terbobot_kriteria[id_kriteria][0] for id_kriteria in normalisasi_terbobot_kriteria if tipe_kriteria[id_kriteria] == 'benefit')
    b_values = sum(normalisasi_terbobot_kriteria[id_kriteria][0] for id_kriteria in normalisasi_terbobot_kriteria if tipe_kriteria[id_kriteria] == 'cost')
    c_values = a_values - b_values

    print("")
    print("a_values")
    print(a_values)
    print("")
    print("b_values")
    print(b_values)
    print("")
    print("c_values")
    print(c_values)

    # Menyimpan hasil perhitungan pada tabel "tbl_skor_moora" dengan mengidentifikasi pemain berdasarkan id posisi pemain
    cur.execute("INSERT INTO tbl_skor_moora (nisn, skor) VALUES (%s, %s) ON CONFLICT (nisn) DO UPDATE SET skor = EXCLUDED.skor", (nisn, c_values))
    conn.commit()


# Baris Function (END) ===============================




# Baris untuk routing (start) ========================

# Halaman registrasi
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        role = request.form['role']

        # Enkripsi password
        hashed_password = hash_password(password)

        # Masukkan data pengguna ke tabel tbl_users
        cur.execute("INSERT INTO tbl_users (username, password, role) VALUES (%s, %s, %s)", (username, hashed_password, role))
        conn.commit()

        return "Registrasi berhasil!"

    return render_template('register.html')



# Halaman Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Enkripsi password
        hashed_password = hash_password(password)

        # Periksa kecocokan username dan password di tabel tbl_users
        cur.execute("SELECT id_user, role, user_data_completed, admin_data_completed FROM tbl_users WHERE username = %s AND password = %s", (username, hashed_password))
        user = cur.fetchone()

        if user:
            user_id, role, user_data_completed, admin_data_completed = user

            # Set sesi pengguna
            session['user_id'] = user_id
            session['role'] = role

            if role == 'user':
                if not user_data_completed:
                    # Jika role user dan data belum lengkap, arahkan ke halaman lengkapi data user
                    return redirect('/lengkapi_data_user')
                else:
                    # Jika role user dan data sudah lengkap, arahkan ke halaman lain untuk pengguna yang sudah login
                    return redirect('/halaman_pengguna')
            elif role == 'admin':
                if not admin_data_completed:
                    # Jika role admin dan data belum lengkap, arahkan ke halaman lengkapi data admin
                    return redirect('/lengkapi_data_admin')
                else:
                    # Jika role admin dan data sudah lengkap, arahkan ke halaman lain untuk admin yang sudah login
                    return redirect('/halaman_admin')
        else:
            # Jika username atau password tidak cocok, kembalikan pesan kesalahan
            error = 'Username atau password salah. Silakan coba lagi.'
            return render_template('login.html', error=error)

    return render_template('login.html')

# Halaman lengkapi data user
@app.route('/lengkapi_data_user', methods=['GET', 'POST'])
def lengkapi_data_user_page():
    if 'user_id' in session and session['role'] == 'user':
        if request.method == 'POST':
            nisn = request.form['nisn']
            nama_pemain = request.form['nama_pemain']
            tgl_lahir_pemain = request.form['tgl_lahir_pemain']
            posisi = request.form['posisi']
            asal_sekolah = request.form['asal_sekolah']

            user_id = session['user_id']
            lengkapi_data_user(nisn, user_id, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah)

            return redirect('/halaman_pengguna')

        return render_template('lengkapi_data_user.html')
    else:
        return redirect('/login')


# Halaman lengkapi data admin
@app.route('/lengkapi_data_admin', methods=['GET', 'POST'])
def lengkapi_data_admin_page():
    if 'user_id' in session and session['role'] == 'admin':
        if request.method == 'POST':
            nama_admin = request.form['nama_admin']
            tgl_lahir_admin = request.form['tgl_lahir_admin']
            jabatan = request.form['jabatan']

            user_id = session['user_id']
            lengkapi_data_admin(user_id, nama_admin, tgl_lahir_admin, jabatan)

            return redirect('/halaman_admin')

        return render_template('lengkapi_data_admin.html')
    else:
        return redirect('/login')


# Halaman pengguna setelah login
@app.route('/halaman_pengguna')
def halaman_pengguna():
    if 'user_id' in session and session['role'] == 'user':
        return "Halaman Pengguna"
    else:
        return redirect('/login')


# Halaman admin setelah login
@app.route('/halaman_admin')
def halaman_admin():
    if 'user_id' in session and session['role'] == 'admin':
        return "Halaman Admin"
    else:
        return redirect('/login')


# Halaman lihat data pemain
@app.route('/lihat_data_pemain', methods=['GET', 'POST'])
def lihat_data_pemain():
    if 'user_id' in session:
        if request.method == 'POST':
            posisi = request.form['posisi']

            if posisi == 'semua':  # Menampilkan semua pemain
                cur.execute("SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain")
            else:
                cur.execute("SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE posisi = %s", (posisi,))

            data_pemain = cur.fetchall()

            return render_template('lihat_data_pemain.html', data_pemain=data_pemain)

        return render_template('lihat_data_pemain.html')
    else:
        return redirect('/login')

# Halaman lihat data tim seleksi
@app.route('/lihat_data_tim_seleksi', methods=['GET', 'POST'])
def lihat_data_tim_seleksi():
    if 'user_id' in session:
        if request.method == 'POST':
            jabatan = request.form['jabatan']

            if jabatan == 'semua':
                cur.execute("SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin WHERE nama_admin != 'Superadmin'")
            else:
                cur.execute("SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin WHERE jabatan = %s AND nama_admin != 'Superadmin'", (jabatan,))

            data_tim_seleksi = cur.fetchall()

            return render_template('lihat_data_tim_seleksi.html', data_tim_seleksi=data_tim_seleksi)

        return render_template('lihat_data_tim_seleksi.html')
    else:
        return redirect('/login')

# Halaman lihat data kriteria berdasarkan posisi atau semua posisi
@app.route('/lihat_data_kriteria', methods=['GET', 'POST'])
def lihat_data_kriteria():
    if request.method == 'POST':
        posisi = request.form['posisi']

        if posisi == 'semua':
            cur.execute("SELECT kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria")
        else:
            cur.execute("SELECT kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria WHERE posisi = %s", (posisi,))

        data_kriteria = cur.fetchall()
        return render_template('lihat_data_kriteria.html', data_kriteria=data_kriteria)

    return render_template('lihat_data_kriteria.html')



# Halaman tambah kriteria
@app.route('/tambah_kriteria', methods=['GET', 'POST'])
def tambah_kriteria():
    if request.method == 'POST':
        kode_kriteria = request.form['kode_kriteria']
        nama_kriteria = request.form['nama_kriteria']
        posisi = request.form['posisi']
        bobot = request.form['bobot']
        tipe = request.form['tipe']

        cur.execute("INSERT INTO tbl_kriteria (kode_kriteria, nama_kriteria, posisi, bobot, tipe) VALUES (%s, %s, %s, %s, %s)", (kode_kriteria, nama_kriteria, posisi, bobot, tipe))
        conn.commit()

        return redirect('/lihat_data_kriteria')

    return render_template('tambah_kriteria.html')

#Halaman penilaian pemain
@app.route('/penilaian_pemain', methods=['GET', 'POST'])
def penilaian_pemain():
    if 'user_id' in session and session['role'] == 'admin':
        # Mengambil data posisi pemain dari tabel tbl_pemain
        cur.execute("SELECT DISTINCT posisi FROM tbl_pemain")
        data_posisi = cur.fetchall()

        if request.method == 'POST' and 'pilih_posisi' in request.form:
            posisi_pemain = request.form['posisi_pemain']

            # Mengambil data pemain berdasarkan posisi yang dipilih
            cur.execute("SELECT nisn, nama_pemain, posisi FROM tbl_pemain WHERE posisi = %s", (posisi_pemain,))
            data_pemain = cur.fetchall()

            return render_template('penilaian_pemain.html', data_posisi=data_posisi, data_pemain=data_pemain)
        
        return render_template('penilaian_pemain.html', data_posisi=data_posisi)
    else:
        return redirect('/login')

# Halaman input nilai pemain
@app.route('/input_nilai_pemain/<nisn>', methods=['GET', 'POST'])
def input_nilai(nisn):
    if 'user_id' in session and session['role'] == 'admin':
        # Mendapatkan data pemain berdasarkan NISN
        cur.execute("SELECT nisn, nama_pemain, posisi FROM tbl_pemain WHERE nisn = %s", (nisn,))
        data_pemain = cur.fetchone()

        # Mendapatkan data kriteria berdasarkan posisi pemain
        cur.execute("SELECT id_kriteria, nama_kriteria FROM tbl_kriteria WHERE posisi = %s", (data_pemain[2],))
        data_kriteria = cur.fetchall()

        if request.method == 'POST':
            # Memasukkan nilai penilaian untuk pemain ke dalam tabel tbl_nilai_kriteria
            for kriteria in data_kriteria:
                nilai = request.form.get("nilai_{}_{}".format(kriteria[0], nisn))
                cur.execute("INSERT INTO tbl_nilai_kriteria (nisn, id_kriteria, nilai) VALUES (%s, %s, %s)", (nisn, kriteria[0], nilai))
                conn.commit()

            # Lakukan perhitungan MOORA dan update hasil pada tabel "tbl_skor_moora" hanya untuk kriteria-kriteria yang sesuai dengan posisi pemain
            hitung_skor_moora(nisn, data_pemain[2], cur, conn)  # data_pemain[2] berisi posisi pemain

            return redirect('/penilaian_pemain')  # Mengarahkan pengguna kembali ke halaman penilaian pemain

        return render_template('input_nilai_pemain.html', data_pemain=data_pemain, data_kriteria=data_kriteria)
    else:
        return redirect('/login')

# Baris untuk routing (end) ========================



# Function to get the list of available player positions
def get_player_positions():
    cur.execute("SELECT DISTINCT posisi FROM tbl_pemain")
    positions = cur.fetchall()
    return [posisi[0] for posisi in positions]

# Halaman data_tbl_nilai_kriteria
@app.route('/data_tbl_nilai_kriteria', methods=['GET', 'POST'])
def data_tbl_nilai_kriteria():
    if 'user_id' in session:  # Make sure the user is logged in (adjust as per your requirements)
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']

            # Query data dari tabel tbl_nilai_kriteria dan gabungkan dengan tbl_pemain dan tbl_kriteria
            cur.execute("SELECT p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Create a DataFrame
            df = pd.DataFrame(data_nilai_kriteria, columns=['nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

            # Use pivot to reshape the DataFrame
            pivot_df = df.pivot(index='nama_pemain', columns='id_kriteria', values='nilai')

            # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
            pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

            # Convert the pivot DataFrame to a list of dictionaries
            table_data = pivot_df.reset_index().to_dict(orient='records')

            return render_template('data_tbl_nilai_kriteria.html', table_data=table_data, positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('data_tbl_nilai_kriteria.html', positions=get_player_positions())
    else:
        return redirect('/login')


# Halaman perhitungan_pemangkatan
@app.route('/perhitungan_pemangkatan', methods=['GET', 'POST'])
def perhitungan_pemangkatan():
    if 'user_id' in session:
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']

            # Query data dari tabel tbl_nilai_kriteria dan gabungkan dengan tbl_pemain dan tbl_kriteria
            cur.execute("SELECT p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Create a DataFrame
            df = pd.DataFrame(data_nilai_kriteria, columns=['nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

            # Use pivot to reshape the DataFrame
            pivot_df = df.pivot(index='nama_pemain', columns='id_kriteria', values='nilai')

            # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
            pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

            # Perform the calculation: nilai * nilai for each criterion
            for kriteria in pivot_df.columns:
                pivot_df[kriteria] = pivot_df[kriteria] ** 2

            # Convert the pivot DataFrame to a list of dictionaries
            table_data = pivot_df.reset_index().to_dict(orient='records')

            return render_template('perhitungan_pemangkatan.html', table_data=table_data, 
                                   criteria=pivot_df.columns, positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('perhitungan_pemangkatan.html', positions=get_player_positions())
    else:
        return redirect('/login')

# Halaman perhitungan_jumlah_pemangkatan
@app.route('/perhitungan_jumlah_pemangkatan', methods=['GET', 'POST'])
def perhitungan_jumlah_pemangkatan():
    if 'user_id' in session:
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']

            # Query data dari tabel tbl_nilai_kriteria dan gabungkan dengan tbl_pemain dan tbl_kriteria
            cur.execute("SELECT p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Create a DataFrame
            df = pd.DataFrame(data_nilai_kriteria, columns=['nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

            # Use pivot to reshape the DataFrame
            pivot_df = df.pivot(index='nama_pemain', columns='id_kriteria', values='nilai')

            # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
            pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

            # Perform the calculation: nilai * nilai for each criterion
            for kriteria in pivot_df.columns:
                pivot_df[kriteria] = pivot_df[kriteria] ** 2

            # Create a new DataFrame to hold the sum of the squared values for each criterion
            sum_df = pd.DataFrame({'kriteria': pivot_df.columns, 'jumlah': pivot_df.sum()})

            # Convert the sum DataFrame to a list of dictionaries
            sum_data = sum_df.to_dict(orient='records')

            return render_template('perhitungan_jumlah_pemangkatan.html', sum_data=sum_data, 
                                   positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('perhitungan_jumlah_pemangkatan.html', positions=get_player_positions())
    else:
        return redirect('/login')



def calculate_sum_of_squared_values(data):
    # Create a DataFrame
    df = pd.DataFrame(data, columns=['nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

    # Use pivot to reshape the DataFrame
    pivot_df = df.pivot(index='nama_pemain', columns='id_kriteria', values='nilai')

    # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
    pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

    # Perform the calculation: nilai * nilai for each criterion
    for kriteria in pivot_df.columns:
        pivot_df[kriteria] = pivot_df[kriteria] ** 2

    # Create a new DataFrame to hold the sum of the squared values for each criterion
    sum_df = pd.DataFrame({'kriteria': pivot_df.columns, 'jumlah': pivot_df.sum()})

    # Calculate the square root of the sum for each criterion
    sum_df['jumlah'] = sum_df['jumlah'].apply(lambda x: math.sqrt(x))

    # Convert the sum DataFrame to a list of dictionaries
    sum_data = sum_df.to_dict(orient='records')

    return sum_data


# Halaman perhitungan_akar_jumlah_pemangkatan
@app.route('/perhitungan_akar_jumlah_pemangkatan', methods=['GET', 'POST'])
def perhitungan_akar_jumlah_pemangkatan():
    if 'user_id' in session:
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']

            # Query data dari tabel tbl_nilai_kriteria dan gabungkan dengan tbl_pemain dan tbl_kriteria
            cur.execute("SELECT p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Calculate the sum of squared values for each criterion
            sum_data = calculate_sum_of_squared_values(data_nilai_kriteria)

            return render_template('perhitungan_akar_jumlah_pemangkatan.html', sum_data=sum_data,
                                   positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('perhitungan_akar_jumlah_pemangkatan.html', positions=get_player_positions())
    else:
        return redirect('/login')

@app.route('/perhitungan_divisi_akar', methods=['GET', 'POST'])
def perhitungan_divisi_akar():
    # Check if the 'user_id' is present in the session (user logged in)
    if 'user_id' in session:
        # Check if the request method is POST (form submitted)
        if request.method == 'POST':
            # Get the selected player position from the form data
            posisi_pemain = request.form['posisi_pemain']

            # Query data from the database for the selected player position
            # and join data from multiple tables to get criteria values
            cur.execute("SELECT p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Calculate the sum of squared values for each criterion
            sum_data = calculate_sum_of_squared_values(data_nilai_kriteria)

            # Create a DataFrame and perform the calculation: nilai * nilai for each criterion
            pivot_df_squared = create_pivot_df(data_nilai_kriteria, squared=True)

            # Create a new DataFrame for the division operation
            pivot_df_divisi_akar = create_pivot_df_divisi_akar(pivot_df_squared, sum_data, posisi_pemain, cur)

            # Convert the values in pivot_df_divisi_akar to decimal.Decimal
            pivot_df_divisi_akar = pivot_df_divisi_akar.applymap(decimal.Decimal)

            # Fetch the criteria types (benefit or cost) from the tbl_kriteria table based on the player's position (posisi_pemain)
            cur.execute("SELECT nama_kriteria, tipe FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
            criteria_types = dict(cur.fetchall())

            # Calculate the Moora value for each player
            pivot_df_divisi_akar['Total Benefit'] = decimal.Decimal(0.0)
            pivot_df_divisi_akar['Total Cost'] = decimal.Decimal(0.0)

            for kriteria in pivot_df_divisi_akar.columns:
                nilai_kriteria = pivot_df_divisi_akar[kriteria]
                tipe_kriteria = criteria_types.get(kriteria)

                if tipe_kriteria == 'benefit':
                    pivot_df_divisi_akar['Total Benefit'] += nilai_kriteria
                elif tipe_kriteria == 'cost':
                    pivot_df_divisi_akar['Total Cost'] += nilai_kriteria

            #   Calculate the Moora value for each player
            pivot_df_divisi_akar['Nilai Moora'] = pivot_df_divisi_akar['Total Benefit'] - pivot_df_divisi_akar['Total Cost']

            # Convert the pivot DataFrame to a list of dictionaries
            table_data = pivot_df_divisi_akar.reset_index().to_dict(orient='records')
            table_data.sort(key=lambda x: x['Nilai Moora'], reverse=True)

            # Render the HTML template with the calculated Moora values and other data
            return render_template('perhitungan_divisi_akar.html', table_data=table_data,
                                   criteria=pivot_df_divisi_akar.columns, positions=get_player_positions(), posisi_pemain=posisi_pemain)

        # If the request method is GET (initial page load)
        # Render the initial page with the dropdown list of player positions
        return render_template('perhitungan_divisi_akar.html', positions=get_player_positions())
    else:
        # If 'user_id' is not present in the session, redirect to the login page
        return redirect('/login')


def create_pivot_df(data, squared=False):
    # Create a DataFrame
    df = pd.DataFrame(data, columns=['nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

    # Use pivot to reshape the DataFrame
    pivot_df = df.pivot(index='nama_pemain', columns='id_kriteria', values='nilai')

    # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
    pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

    if squared:
        # Perform the calculation: nilai * nilai for each criterion
        for kriteria in pivot_df.columns:
            pivot_df[kriteria] = pivot_df[kriteria] ** 2

    return pivot_df


def create_pivot_df_divisi_akar(pivot_df_squared, sum_data, posisi_pemain, cur):
    # Create a new DataFrame to hold the division values for each criterion
    pivot_df_divisi_akar = pivot_df_squared.copy()

    # Fetch the weights (bobot) from the tbl_kriteria table based on the player's position (posisi_pemain)
    cur.execute("SELECT nama_kriteria, bobot FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
    kriteria_weights = dict(cur.fetchall())

    # Perform the calculation: (nilai / akar_jumlah_pemangkatan) * bobot for each criterion
    for kriteria in pivot_df_divisi_akar.columns:
        sum_value = next((item['jumlah'] for item in sum_data if item['kriteria'] == kriteria), None)
        sum_value_decimal = decimal.Decimal(sum_value)  # Convert sum_value to decimal.Decimal
        bobot = decimal.Decimal(kriteria_weights.get(kriteria, 1.0))  # Default weight is 1.0 if not found
        pivot_df_divisi_akar[kriteria] = (np.sqrt(pivot_df_divisi_akar[kriteria]) / sum_value_decimal) * bobot

    return pivot_df_divisi_akar


if __name__ == '__main__':
    app.run(debug=True)