from flask import Flask, render_template, request, session, redirect
import psycopg2
import hashlib
import jinja2.ext

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

# Fungsi untuk menghitung nilai Moora
def calculate_moora(nisn):
    # Mengambil data kriteria dari tabel tbl_kriteria
    cur.execute("SELECT id_kriteria, nama_kriteria, tipe, bobot FROM tbl_kriteria WHERE posisi = (SELECT posisi FROM tbl_pemain WHERE nisn = %s)", (nisn,))
    data_kriteria = cur.fetchall()

    # Mengambil nilai kriteria dari tabel tbl_nilai_kriteria untuk pemain dengan nisn tertentu
    cur.execute("SELECT id_kriteria, nilai FROM tbl_nilai_kriteria WHERE nisn = %s", (nisn,))
    nilai_kriteria = cur.fetchall()

    if len(nilai_kriteria) != len(data_kriteria):
        return None  # Jumlah kriteria tidak sesuai, hasil perhitungan tidak valid

    # Hitung nilai normalisasi (cost atau benefit) berdasarkan tipe kriteria
    for i in range(len(nilai_kriteria)):
        id_kriteria = nilai_kriteria[i][0]
        tipe_kriteria = [k[2] for k in data_kriteria if k[0] == id_kriteria][0]
        if tipe_kriteria == 'cost':
            nilai_kriteria[i] = min(nilai_kriteria[i][1])
        elif tipe_kriteria == 'benefit':
            nilai_kriteria[i] = max(nilai_kriteria[i][1])

    # Normalisasi bobot agar jumlah bobot menjadi 1
    total_bobot = sum([x[3] for x in data_kriteria])
    bobot_normalisasi = [x[3] / total_bobot for x in data_kriteria]

    # Hitung nilai Moora
    nilai_moora = sum([x * y for x, y in zip(nilai_kriteria, bobot_normalisasi)])

    # Memasukkan nilai Moora ke dalam tabel tbl_skor_moora
    cur.execute("INSERT INTO tbl_skor_moora (nisn, skor, status) VALUES (%s, %s, %s)",
                (nisn, nilai_moora, "Belum Dikonfirmasi"))
    conn.commit()

    return nilai_moora


# Function untuk memperbarui peringkat di tabel tbl_skor_moora
def update_peringkat():
    # Ambil data skor Moora dan NISN dari tabel tbl_skor_moora
    cur.execute("SELECT nisn, skor FROM tbl_skor_moora ORDER BY skor DESC")
    data_skor_moora = cur.fetchall()

    # Perbarui peringkat berdasarkan skor Moora
    peringkat = 1
    for nisn, _ in data_skor_moora:
        cur.execute("UPDATE tbl_skor_moora SET peringkat = %s WHERE nisn = %s", (peringkat, nisn))
        conn.commit()
        peringkat += 1


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



# Baris untuk routing (end) ========================

if __name__ == '__main__':
    app.run(debug=True)
