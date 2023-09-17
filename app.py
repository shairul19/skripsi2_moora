from flask import Flask, render_template, request, session, redirect, make_response, flash
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
from flask_paginate import Pagination, get_page_args

app = Flask(__name__)
app.secret_key = 'wasdqwerty'
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

# Function cek username
def cek_username(username):
    cur.execute(
        "SELECT COUNT(*) FROM tbl_users WHERE username = %s", (username,))
    count = cur.fetchone()[0]
    return count > 0


# Function untuk mengenkripsi password menggunakan SHA256
def hash_password(password):
    sha256_hash = hashlib.sha256()
    sha256_hash.update(password.encode('utf-8'))
    return sha256_hash.hexdigest()


# Function cek nisn
def cek_nisn(nisn):
    cur.execute(
        "SELECT COUNT(*) FROM tbl_pemain WHERE nisn = %s", (nisn,))
    count = cur.fetchone()[0]
    return count > 0




# Function lengkapi data user
def lengkapi_data_user(nisn, user_id, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah):
    # Masukkan data ke tabel tbl_pemain
    cur.execute("INSERT INTO tbl_pemain (nisn, id_user, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah) VALUES (%s, %s, %s, %s, %s, %s)",
                (nisn, user_id, nama_pemain, tgl_lahir_pemain, posisi, asal_sekolah))
    conn.commit()

    # Perbarui status data completed pada tabel tbl_users
    cur.execute(
        "UPDATE tbl_users SET user_data_completed = TRUE WHERE id_user = %s", (user_id,))
    conn.commit()


# Function untuk melengkapi data admin
def lengkapi_data_admin(user_id, nama_admin, tgl_lahir_admin, jabatan):
    # Masukkan data ke tabel tbl_admin
    cur.execute("INSERT INTO tbl_admin (id_user, nama_admin, tgl_lahir_admin, jabatan) VALUES (%s, %s, %s, %s)",
                (user_id, nama_admin, tgl_lahir_admin, jabatan))
    conn.commit()

    # Perbarui status data completed pada tabel tbl_users
    cur.execute(
        "UPDATE tbl_users SET admin_data_completed = TRUE WHERE id_user = %s", (user_id,))
    conn.commit()




# Function mengambil username
def get_username(user_id):
    cur.execute("SELECT username FROM tbl_users WHERE id_user = %s", (user_id,))
    conn.commit()
    username = cur.fetchone()[0]
    return username

# Function mengambil data untuk profil pemain
def get_user_profile(user_id):
    cur.execute("SELECT u.id_user, u.username, p.nisn, p.nama_pemain, p.tgl_lahir_pemain, p.posisi, p.asal_sekolah "
                "FROM tbl_users u "
                "JOIN tbl_pemain p ON u.id_user = p.id_user "
                "WHERE u.id_user = %s", (user_id,))
    user_profile = cur.fetchone()
    return user_profile


# Function mengambil data untuk profil admin
def get_admin_profile(user_id):
    cur.execute("SELECT a.id_user, a.id_admin, a.nama_admin, a.tgl_lahir_admin, a.Jabatan, u.username "
                "FROM tbl_admin a "
                "JOIN tbl_users u ON a.id_user = u.id_user "
                "WHERE a.id_user = %s", (user_id,))
    admin_profile = cur.fetchone()
    return admin_profile


# Fungsi cek id_kriteria pada tbl_nilai_kriteria
def is_kriteria_used(id_kriteria):
    cur.execute(
        "SELECT COUNT(*) FROM tbl_nilai_kriteria WHERE id_kriteria = %s", (id_kriteria,))
    count = cur.fetchone()[0]
    return count > 0


# function cek id_user pada tbl_pemain
def check_pemain_for_user(user_id):
    # Lakukan query untuk memeriksa apakah ada data pemain terkait dengan user_id
    query = "SELECT COUNT(*) FROM tbl_pemain WHERE id_user = %s"
    cur.execute(query, (user_id,))
    count = cur.fetchone()[0]

    return count > 0  # Mengembalikan True jika ada data pemain, False jika tidak


# function cek id_user pada tbl_admin
def check_admin_for_user(user_id):
    query = "SELECT COUNT(*) FROM tbl_admin WHERE id_user = %s"
    cur.execute(query, (user_id,))
    count = cur.fetchone()[0]

    return count > 0


# Baris Function (END) ===============================


# Baris untuk routing (start) ========================

# Halaman awal ketika akses
@app.route('/')
def halaman_awal():
    return redirect('/login')

# Halaman registrasi
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username'].lower()
        password = request.form['password']
        role = request.form['role']

        if cek_username(username):
            # jika username sudah ada, tampilkan pesan error
            error_message = "Username sudah terdaftar. Silakan pilih username lain."
            return render_template('register.html', error_message=error_message)

        # Enkripsi password
        hashed_password = hash_password(password)

        try:
            cur.execute("INSERT INTO tbl_users (username, password, role) VALUES (%s, %s, %s)",
                        (username, hashed_password, role))
            conn.commit()
            # Pendaftaran berhasil
            success = "User berhasil didaftarkan"
            return render_template('register.html', success=success)
        except Exception as e:
            # Gagal memasukkan data, tampilkan pesan error
            error_message_db = "Gagal mendaftarkan user. Silakan coba lagi."
            return render_template('register.html', error_message_db=error_message_db)

    return render_template('register.html')


# Halaman Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username'].lower()
        password = request.form['password']

        # Enkripsi password
        hashed_password = hash_password(password)

        # Periksa kecocokan username dan password di tabel tbl_users
        cur.execute("SELECT id_user, role, user_data_completed, admin_data_completed FROM tbl_users WHERE username = %s AND password = %s",
                    (username, hashed_password))
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
                    # Jika role user dan data sudah lengkap, arahkan ke halaman dashboard pengguna
                    return redirect('/halaman_pengguna')
            elif role == 'admin' or role == 'superadmin':
                if not admin_data_completed:
                    # Jika role admin atau superadmin dan data belum lengkap, arahkan ke halaman lengkapi data admin
                    return redirect('/lengkapi_data_admin')
                else:
                    # Jika role admin atau superadmin dan data sudah lengkap, arahkan ke halaman dashboard admin
                    return redirect('/halaman_admin')
        else:
            # Jika username atau password tidak cocok, munculkan pesan kesalahan
            error = 'Username atau password salah. Silakan coba lagi.'
            return render_template('login.html', error=error)

    return render_template('login.html')


# Halaman Logout
@app.route('/logout')
def logout():
    # Membersihkan Session
    session.pop('user_id', None) #membersihkan info user_id
    session.pop('role', None) #mmebersihkan info role

    response = make_response(redirect('/login')) #mengarahkan ke halaman login
    
    #menghapus cache pada browser
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate' 
    response.headers['Pragma'] = 'no-cache' 
    response.headers['Expires'] = 0

    return response


# Halaman lengkapi data user
@app.route('/lengkapi_data_user', methods=['GET', 'POST'])
def lengkapi_data_user_page():
    if 'user_id' in session and session['role'] == 'user':
        if request.method == 'POST':
            nisn = request.form['nisn']
            nama_pemain = request.form['nama_pemain'].upper()
            tgl_lahir_pemain = request.form['tgl_lahir_pemain']
            posisi = request.form['posisi']
            asal_sekolah = request.form['asal_sekolah'].upper()

            if cek_nisn(nisn):
                # jika nisn sudah ada, tampilkan pesan error
                error_message = "nisn sudah terdaftar. Silakan hubungi admin."
                return render_template('lengkapi_data_user.html', error_message=error_message)

            user_id = session['user_id']

            lengkapi_data_user(nisn, user_id, nama_pemain,
                               tgl_lahir_pemain, posisi, asal_sekolah)

            return redirect('/halaman_pengguna')

        return render_template('lengkapi_data_user.html')
    else:
        return redirect('/login')


# Halaman lengkapi data admin
@app.route('/lengkapi_data_admin', methods=['GET', 'POST'])
def lengkapi_data_admin_page():
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        if request.method == 'POST':
            nama_admin = request.form['nama_admin'].upper()
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
        #menghitung jumlah pemain pada tbl_pemain
        cur.execute("SELECT COUNT (*) FROM tbl_pemain")
        conn.commit()
        jumlah_pemain = cur.fetchone()[0]

        #menghitung jumlah tim seleksi pada tbl_admin
        cur.execute("SELECT COUNT (*) FROM tbl_admin WHERE jabatan != 'superadmin' ")
        conn.commit()
        jumlah_penilai = cur.fetchone()[0]

        #menghitung jumlah pemain yang dinilai pada tbl_nilai_kriteria yang dicek dengan nisn
        cur.execute("SELECT COUNT (DISTINCT Nisn) FROM tbl_nilai_kriteria")
        conn.commit()
        jumlah_pemain_dinilai = cur.fetchone()[0]

        # Mengambil username untuk ditampilkan di navbar
        user_id = session['user_id']
        username = get_username(user_id)

        return render_template('dashboard.html', username=username, jumlah_pemain=jumlah_pemain, jumlah_penilai=jumlah_penilai, jumlah_pemain_dinilai=jumlah_pemain_dinilai)
    else:
        return redirect('/login')


# Halaman admin setelah login
@app.route('/halaman_admin')
def halaman_admin():
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        #menghitung jumlah pemain pada tbl_pemain
        cur.execute("SELECT COUNT (*) FROM tbl_pemain")
        conn.commit()
        jumlah_pemain = cur.fetchone()[0]

        #menghitung jumlah tim seleksi pada tbl_admin
        cur.execute(
            "SELECT COUNT (*) FROM tbl_admin WHERE jabatan != 'superadmin' ")
        conn.commit()
        jumlah_penilai = cur.fetchone()[0]

        #menghitung jumlah pemain yang dinilai pada tbl_nilai_kriteria yang dicek dengan nisn
        cur.execute("SELECT COUNT (DISTINCT Nisn) FROM tbl_nilai_kriteria")
        conn.commit()
        jumlah_pemain_dinilai = cur.fetchone()[0]

        # Mengambil username untuk ditampilkan di navbar
        user_id = session['user_id']
        username = get_username(user_id)

        return render_template('dashboard.html', username=username, jumlah_pemain=jumlah_pemain, jumlah_penilai=jumlah_penilai, jumlah_pemain_dinilai=jumlah_pemain_dinilai)
    else:
        return redirect('/login')


# Halaman Profil Pemain
@app.route('/profil')
def profil():
    if 'user_id' in session and session['role'] == 'user':
        user_id = session['user_id']
        user_profile = get_user_profile(user_id)

        # Mengambil username untuk ditampilkan di navbar
        username = get_username(user_id)

        return render_template('profil_pemain.html', username=username, user_profile=user_profile)
    else:
        user_id = session['user_id']
        admin_profile = get_admin_profile(user_id)

        username = get_username(user_id)
        return render_template('profil_admin.html', username=username, admin_profile=admin_profile)

    return redirect('/login')


# Halaman update profil
@app.route('/update_profil', methods=['GET', 'POST'])
def update_profil():
    if 'user_id' in session:
        user_id = session['user_id']
        role = session['role']
        # Mengambil username untuk ditampilkan di navbar
        username = get_username(user_id)

        if role == 'user':
            user_profile = get_user_profile(user_id)

            if request.method == 'POST':
                nama_pemain = request.form['nama_pemain'].upper()
                tgl_lahir_pemain = request.form['tgl_lahir_pemain']
                asal_sekolah = request.form['asal_sekolah'].upper()

                # Update data profil pemain
                cur.execute("UPDATE tbl_pemain SET nama_pemain = %s, tgl_lahir_pemain = %s, asal_sekolah = %s WHERE id_user = %s",
                            (nama_pemain, tgl_lahir_pemain, asal_sekolah, user_id))
                conn.commit()

                return redirect('/profil')

            return render_template('update_profil.html', username=username, user_profile=user_profile)

        elif role == 'admin' or role == 'superadmin':
            admin_profile = get_admin_profile(user_id)

            if request.method == 'POST':
                nama_admin = request.form['nama_admin'].upper()
                tgl_lahir_admin = request.form['tgl_lahir_admin']
                jabatan = request.form['jabatan']

                # Update data profil admin
                cur.execute("UPDATE tbl_admin SET nama_admin = %s, tgl_lahir_admin = %s, jabatan = %s WHERE id_user = %s",
                            (nama_admin, tgl_lahir_admin, jabatan, user_id))
                conn.commit()

                return redirect('/profil')

            return render_template('update_profil.html', username=username, admin_profile=admin_profile)
    else:
        return redirect('/login')


# Halaman lihat data pemain
@app.route('/lihat_data_pemain', methods=['GET', 'POST'])
def lihat_data_pemain():
    if 'user_id' in session:
        # Mengambil username untuk ditampilkan di navbar
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            posisi = request.form['posisi']
            search = request.form.get('search', '')

            # Menghitung total data setelah menerapkan filter pencarian
            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s"
                cur.execute(total_data_query,
                            (f'%{search}%', f'%{search}%', f'%{search}%'))
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE posisi = %s AND (nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s)"
                cur.execute(total_data_query, (posisi,
                            f'%{search}%', f'%{search}%', f'%{search}%'))
            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10

            # Hitung total halaman setelah filter pencarian
            total_pages = max(math.ceil(total_data / per_page), 1)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil data pemain untuk halaman tertentu
            if posisi == 'semua':
                query = "SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s LIMIT %s OFFSET %s"
                cur.execute(
                    query, (f'%{search}%', f'%{search}%', f'%{search}%', per_page, offset))
            else:
                query = "SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE (posisi = %s) AND (nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s) LIMIT %s OFFSET %s"
                cur.execute(
                    query, (posisi, f'%{search}%', f'%{search}%', f'%{search}%', per_page, offset))

            data_pemain = cur.fetchall()

            return render_template('lihat_data_pemain.html', username=username, data_pemain=data_pemain, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page, search=search)
        else:
            # Mengambil posisi dari parameter URL saat berpindah halaman
            posisi = request.args.get('posisi', 'semua')
            search = request.args.get('search', '')

            # Mengambil username untuk ditampilkan di navbar
            user_id = session['user_id']
            cur.execute(
                "SELECT username FROM tbl_users WHERE id_user = %s", (user_id,))
            conn.commit()

            username = get_username(user_id)

            # Menghitung total data setelah menerapkan filter pencarian
            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s"
                cur.execute(total_data_query,
                            (f'%{search}%', f'%{search}%', f'%{search}%'))
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE posisi = %s AND (nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s)"
                cur.execute(total_data_query, (posisi,
                            f'%{search}%', f'%{search}%', f'%{search}%'))
            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10

            # Hitung total halaman setelah filter pencarian
            total_pages = max(math.ceil(total_data / per_page), 1)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil data pemain untuk halaman tertentu
            if posisi == 'semua':
                query = "SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s LIMIT %s OFFSET %s"
                cur.execute(
                    query, (f'%{search}%', f'%{search}%', f'%{search}%', per_page, offset))
            else:
                query = "SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE (posisi = %s) AND (nisn LIKE %s OR nama_pemain LIKE %s OR asal_sekolah LIKE %s) LIMIT %s OFFSET %s"
                cur.execute(
                    query, (posisi, f'%{search}%', f'%{search}%', f'%{search}%', per_page, offset))

            data_pemain = cur.fetchall()

            return render_template('lihat_data_pemain.html', username=username, data_pemain=data_pemain, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page, search=search)
    else:
        return redirect('/login')


# Halaman Edit Data Pemain
@app.route('/edit_data_pemain/<nisn>', methods=['GET', 'POST'])
def edit_data_pemain(nisn):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        # Mengambil username untuk ditampilkan di navbar
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            nama_baru = request.form['nama'].upper()
            posisi_baru = request.form['posisi']
            tgl_lahir_baru = request.form['tgl_lahir']
            asal_sekolah_baru = request.form['asal_sekolah'].upper()

            # Update data pemain dalam database
            cur.execute("UPDATE tbl_pemain SET nama_pemain = %s, posisi = %s, tgl_lahir_pemain = %s, asal_sekolah = %s WHERE nisn = %s",
                        (nama_baru, posisi_baru, tgl_lahir_baru, asal_sekolah_baru, nisn))

            # Commit perubahan ke database
            conn.commit()

            return redirect('/lihat_data_pemain')

        # Ambil data pemain berdasarkan nisn
        cur.execute(
            "SELECT nisn, nama_pemain, posisi, tgl_lahir_pemain, asal_sekolah FROM tbl_pemain WHERE nisn = %s", (nisn,))
        data_pemain = cur.fetchone()

        return render_template('edit_data_pemain.html', username=username, data_pemain=data_pemain)
    else:
        return redirect('/lihat_data_pemain')


# Halaman Hapus Data Pemain
@app.route('/hapus_data_pemain/<string:nisn>', methods=['POST'])
def hapus_data_pemain(nisn):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        try:
            # Hapus data pemain dari tbl_nilai_kriteria
            cur.execute(
                "DELETE FROM tbl_nilai_kriteria WHERE nisn = %s", (nisn,))
            conn.commit()

            # Hapus data pemain dari tbl_pemain
            cur.execute("DELETE FROM tbl_pemain WHERE nisn = %s", (nisn,))
            conn.commit()

            flash('Data pemain berhasil dihapus', 'success')
            return redirect('/lihat_data_pemain')
        except Exception as e:
            print("Error:", e)
            conn.rollback()
            flash('Terjadi kesalahan saat menghapus data pemain', 'error')
            return redirect('/lihat_data_pemain')
    else:
        return redirect('/login')


# Halaman lihat data tim seleksi
@app.route('/lihat_data_tim_seleksi', methods=['GET', 'POST'])
def lihat_data_tim_seleksi():
    if 'user_id' in session:
        user_id = session['user_id']
        username = get_username(user_id)

        if request.method == 'POST':
            jabatan = request.form['jabatan']

            # menghitung total data
            if jabatan == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_admin"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_admin WHERE jabatan = %s"
                cur.execute(total_data_query, (jabatan,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil Data admin untuk halaman tertentu
            if jabatan == 'semua':
                query = "SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin WHERE jabatan != 'superadmin' LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin WHERE jabatan = %s  LIMIT %s OFFSET %s"
                cur.execute(query, (jabatan, per_page, offset))

            data_tim_seleksi = cur.fetchall()

            return render_template('lihat_data_tim_seleksi.html', username=username, data_tim_seleksi=data_tim_seleksi, total_pages=total_pages, current_page=page, jabatan=jabatan, per_page=per_page)

        else:
            # Mengambil jabatan dari parameter URL saat berpindah halaman
            jabatan = request.args.get('jabatan', 'semua')

            # menghitung total data
            if jabatan == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_admin"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_admin WHERE jabatan = %s"
                cur.execute(total_data_query, (jabatan,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil Data admin untuk halaman tertentu
            if jabatan == 'semua':
                query = "SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin  WHERE jabatan != 'superadmin' LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_admin, nama_admin, tgl_lahir_admin, jabatan FROM tbl_admin WHERE jabatan = %s LIMIT %s OFFSET %s"
                cur.execute(query, (jabatan, per_page, offset))

            data_tim_seleksi = cur.fetchall()

            return render_template('lihat_data_tim_seleksi.html', username=username, data_tim_seleksi=data_tim_seleksi, total_pages=total_pages, current_page=page, jabatan=jabatan, per_page=per_page)

    else:
        return redirect('/login')


# Halaman Hapus Data Tim Seleksi
@app.route('/hapus_data_admin/<int:id_admin>', methods=['POST'])
def hapus_data_admin(id_admin):
    if 'user_id' in session and session['role'] == 'superadmin':
        # Lakukan operasi delete di sini, misalnya dengan menggunakan query SQL
        cur.execute(
            "DELETE FROM tbl_admin WHERE id_admin = %s", (id_admin,))
        conn.commit()  # Jangan lupa untuk commit perubahan
        # Tampilkan pesan sukses
        flash('Data Admin berhasil dihapus', 'success')
        return redirect('/lihat_data_tim_seleksi')
    else:
        flash('Anda tidak memiliki izin untuk menghapus data kriteria',
              'danger')  # Tampilkan pesan error
        return redirect('/lihat_data_tim_seleksi')


# Halaman lihat data kriteria
@app.route('/lihat_data_kriteria', methods=['GET', 'POST'])
def lihat_data_kriteria():
    if 'user_id' in session:
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            posisi = request.form['posisi']

            # Menghitung total data
            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_kriteria"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_kriteria WHERE posisi = %s"
                cur.execute(total_data_query, (posisi,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil data pemain untuk halaman tertentu
            if posisi == 'semua':
                query = "SELECT id_kriteria, kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_kriteria, kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria WHERE posisi = %s LIMIT %s OFFSET %s"
                cur.execute(query, (posisi, per_page, offset))

            data_kriteria = cur.fetchall()
            # Mengambil semua id_kriteria dari tbl_nilai_kriteria
            cur.execute("SELECT DISTINCT id_kriteria FROM tbl_nilai_kriteria")
            id_kriteria_nilai = [row[0] for row in cur.fetchall()]

            return render_template('lihat_data_kriteria.html', username=username, data_kriteria=data_kriteria, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page, id_kriteria_nilai=id_kriteria_nilai)

        else:
            # Mengambil posisi dari parameter URL saat berpindah halaman
            posisi = request.args.get('posisi', 'semua')

            # Menghitung total data
            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_kriteria"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_kriteria WHERE posisi = %s"
                cur.execute(total_data_query, (posisi,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            # Mengambil data pemain untuk halaman tertentu
            if posisi == 'semua':
                query = "SELECT id_kriteria, kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_kriteria, kode_kriteria, nama_kriteria, posisi, bobot, tipe FROM tbl_kriteria WHERE posisi = %s LIMIT %s OFFSET %s"
                cur.execute(query, (posisi, per_page, offset))

            data_kriteria = cur.fetchall()

            cur.execute("SELECT DISTINCT id_kriteria FROM tbl_nilai_kriteria")
            id_kriteria_nilai = [row[0] for row in cur.fetchall()]

            return render_template('lihat_data_kriteria.html', username=username, data_kriteria=data_kriteria, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page, id_kriteria_nilai=id_kriteria_nilai)

    else:
        return redirect('/login')

# Halaman Tambah Kriteria


@app.route('/tambah_kriteria', methods=['GET', 'POST'])
def tambah_kriteria():
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            kode_kriteria = request.form['kode_kriteria'].upper()
            nama_kriteria = request.form['nama_kriteria']
            posisi = request.form['posisi']
            bobot = Decimal(request.form['bobot'])
            tipe = request.form['tipe']

            # Mengambil total bobot untuk setiap posisi dari database
            cur.execute(
                "SELECT posisi, SUM(bobot) FROM tbl_kriteria GROUP BY posisi")
            total_bobot_per_position = {row[0]: row[1]
                                        for row in cur.fetchall()}

            # Mendapatkan total bobot untuk posisi tertentu
            total_bobot_posisi = total_bobot_per_position.get(
                posisi, Decimal(0))

            # Memeriksa apakah total bobot untuk posisi tertentu melebihi 1.0
            if total_bobot_posisi + bobot > 1.0:
                flash('Total Bobot sudah lebih dari 1.0, harap cek kembali kriteria lainnya pada posisi tersebut',
                      'danger')
                return render_template('tambah_kriteria.html', username=username, total_bobot_posisi=total_bobot_per_position)

            # Jika total bobot masih dalam batas, simpan data ke database
            cur.execute("INSERT INTO tbl_kriteria (kode_kriteria, nama_kriteria, posisi, bobot, tipe) VALUES (%s, %s, %s, %s, %s)",
                        (kode_kriteria, nama_kriteria, posisi, bobot, tipe))
            conn.commit()

            return redirect('/lihat_data_kriteria')

        # Mengambil total bobot untuk setiap posisi dari database
        cur.execute(
            "SELECT posisi, SUM(bobot) FROM tbl_kriteria GROUP BY posisi")
        total_bobot_per_position = {row[0]: row[1] for row in cur.fetchall()}

        return render_template('tambah_kriteria.html', username=username, total_bobot_posisi=total_bobot_per_position)
    else:
        flash('Anda tidak memiliki izin untuk menambah data kriteria', 'danger')
        return redirect('/lihat_data_kriteria')


# Fungsi Hapus Kriteria
@app.route('/hapus_data_kriteria/<int:id_kriteria>', methods=['POST'])
def hapus_data_kriteria(id_kriteria):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        # Lakukan operasi delete di sini, misalnya dengan menggunakan query SQL
        cur.execute(
            "DELETE FROM tbl_kriteria WHERE id_kriteria = %s", (id_kriteria,))
        conn.commit()  # Jangan lupa untuk commit perubahan
        flash('Data kriteria berhasil dihapus',
              'success')  # Tampilkan pesan sukses
        return redirect('/lihat_data_kriteria')
    else:
        flash('Anda tidak memiliki izin untuk menghapus data kriteria',
              'danger')  # Tampilkan pesan error
        return redirect('/lihat_data_kriteria')


# Fungsi untuk mengedit kriteria
@app.route('/edit_kriteria/<int:id_kriteria>', methods=['GET', 'POST'])
def edit_kriteria(id_kriteria):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        cur.execute("SELECT id_kriteria, kode_kriteria, nama_kriteria, posisi, tipe, bobot "
                    "FROM tbl_kriteria WHERE id_kriteria = %s", (id_kriteria,))
        kriteria = cur.fetchone()

        if request.method == 'POST':
            kode_kriteria = kriteria[1]
            nama_kriteria = request.form['nama_kriteria']
            posisi = kriteria[3]
            tipe = request.form['tipe']
            bobot = Decimal(request.form['bobot'])

            # Mengambil total bobot untuk setiap posisi dari database
            cur.execute(
                "SELECT posisi, SUM(bobot) FROM tbl_kriteria GROUP BY posisi")
            total_bobot_per_position = {row[0]: row[1]
                                        for row in cur.fetchall()}

            # Mendapatkan total bobot untuk posisi tertentu
            total_bobot_posisi = total_bobot_per_position.get(
                posisi, Decimal(0))

            # Memeriksa apakah total bobot untuk posisi tertentu melebihi 1.0
            if total_bobot_posisi - kriteria[5] + bobot > 1.0:
                flash('Total Bobot sudah lebih dari 1.0, harap cek kembali kriteria lainnya pada posisi tersebut',
                      'danger')
                return render_template('edit_kriteria.html', kriteria=kriteria, username=username, total_bobot_posisi=total_bobot_per_position)
            

            # Jika total bobot masih dalam batas, update dan simpan data ke database
            cur.execute("UPDATE tbl_kriteria "
                        "SET kode_kriteria = %s, nama_kriteria = %s, posisi = %s, tipe = %s, bobot = %s "
                        "WHERE id_kriteria = %s",
                        (kode_kriteria, nama_kriteria, posisi, tipe, bobot, id_kriteria))
            conn.commit()
            flash('Kriteria Berhasil diubah',
                      'success')
            return redirect('/lihat_data_kriteria')

         # Mengambil total bobot untuk setiap posisi dari database
        cur.execute(
            "SELECT posisi, SUM(bobot) FROM tbl_kriteria GROUP BY posisi")
        total_bobot_per_position = {row[0]: row[1] for row in cur.fetchall()}

        return render_template('edit_kriteria.html', username=username, kriteria=kriteria, total_bobot_posisi=total_bobot_per_position)
    else:
        flash('Anda tidak memiliki izin untuk mengedit data kriteria',
              'danger')
        return redirect('/lihat_data_kriteria')


# Halaman penilaian pemain
@app.route('/penilaian_pemain', methods=['GET', 'POST'])
def penilaian_pemain():
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        # Mengambil NISN pemain yang sudah memiliki nilai dalam tbl_nilai_kriteria
        cur.execute("SELECT DISTINCT nisn FROM tbl_nilai_kriteria")
        data_nilai_pemain = [row[0] for row in cur.fetchall()]

        # Hitung total bobot untuk posisi pemain yang dipilih

        if request.method == 'POST':
            posisi = request.form['posisi']

            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE posisi = %s"
                cur.execute(total_data_query, (posisi,))

            total_data = cur.fetchone()[0]
            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            if posisi == 'semua':
                query = "SELECT nisn, nama_pemain, posisi FROM tbl_pemain LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT nisn, nama_pemain, posisi FROM tbl_pemain WHERE posisi = %s LIMIT %s OFFSET %s"
                cur.execute(query, (posisi, per_page, offset))

            data_pemain = cur.fetchall()

            return render_template('penilaian_pemain.html', username=username, data_pemain=data_pemain, data_nilai_pemain=data_nilai_pemain, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page)
        else:
            posisi = request.args.get('posisi', 'semua')

            if posisi == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_pemain WHERE posisi = %s"
                cur.execute(total_data_query, (posisi,))

            total_data = cur.fetchone()[0]
            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            if posisi == 'semua':
                query = "SELECT nisn, nama_pemain, posisi FROM tbl_pemain LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT nisn, nama_pemain, posisi FROM tbl_pemain WHERE posisi = %s LIMIT %s OFFSET %s"
                cur.execute(query, (posisi, per_page, offset))

            data_pemain = cur.fetchall()

            return render_template('penilaian_pemain.html', username=username, data_pemain=data_pemain, data_nilai_pemain=data_nilai_pemain, total_pages=total_pages, current_page=page, posisi=posisi, per_page=per_page)
    else:
        return redirect('/data_nilai_pemain')


# Halaman input nilai pemain
@app.route('/input_nilai_pemain/<nisn>', methods=['GET', 'POST'])
def input_nilai(nisn):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        # Mendapatkan data pemain berdasarkan NISN
        cur.execute(
            "SELECT nisn, nama_pemain, posisi FROM tbl_pemain WHERE nisn = %s", (nisn,))
        data_pemain = cur.fetchone()

        # Mendapatkan data kriteria berdasarkan posisi pemain
        cur.execute(
            "SELECT id_kriteria, nama_kriteria FROM tbl_kriteria WHERE posisi = %s", (data_pemain[2],))
        data_kriteria = cur.fetchall()

        if request.method == 'POST':
            # Memasukkan nilai penilaian untuk pemain ke dalam tabel tbl_nilai_kriteria
            for kriteria in data_kriteria:
                nilai = request.form.get(
                    "nilai_{}_{}".format(kriteria[0], nisn))
                cur.execute(
                    "INSERT INTO tbl_nilai_kriteria (nisn, id_kriteria, nilai) VALUES (%s, %s, %s)", (nisn, kriteria[0], nilai))
                conn.commit()

            # Flash a success message
            flash('Penilaian Berhasil!', 'success')
            # Mengarahkan pengguna kembali ke halaman penilaian pemain
            return redirect('/penilaian_pemain')

        return render_template('input_nilai_pemain.html', username=username, data_pemain=data_pemain, data_kriteria=data_kriteria)
    else:
        return redirect('/login')


# Halaman Data User
@app.route('/lihat_data_user', methods=['GET', 'POST'])
def lihat_data_user():
    if 'user_id' in session and session['role'] == 'superadmin':
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            role = request.form['role']

            if role == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_users"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_users WHERE role = %s"
                cur.execute(total_data_query, (role,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            if role == 'semua':
                query = "SELECT id_user, username, role, created_at, updated_at, admin_data_completed, user_data_completed FROM tbl_users LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_user, username, role, created_at, updated_at, admin_data_completed, user_data_completed FROM tbl_users WHERE role = %s LIMIT %s OFFSET %s"
                cur.execute(query, (role, per_page, offset))

            data_users = cur.fetchall()

            return render_template('lihat_data_user.html', username=username, check_pemain_for_user=check_pemain_for_user, check_admin_for_user=check_admin_for_user, data_users=data_users,  total_pages=total_pages, current_page=page, role=role, per_page=per_page)

        else:
            role = request.args.get('role', 'semua')

            if role == 'semua':
                total_data_query = "SELECT COUNT(*) FROM tbl_users"
                cur.execute(total_data_query)
            else:
                total_data_query = "SELECT COUNT(*) FROM tbl_users WHERE role = %s"
                cur.execute(total_data_query, (role,))

            total_data = cur.fetchone()[0]

            # Jumlah data per halaman
            per_page = 10
            total_pages = math.ceil(total_data / per_page)

            # Mendapatkan halaman saat ini dari parameter URL
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            if role == 'semua':
                query = "SELECT id_user, username, role, created_at, updated_at, admin_data_completed, user_data_completed FROM tbl_users LIMIT %s OFFSET %s"
                cur.execute(query, (per_page, offset))
            else:
                query = "SELECT id_user, username, role, created_at, updated_at, admin_data_completed, user_data_completed FROM tbl_users WHERE role = %s LIMIT %s OFFSET %s"
                cur.execute(query, (role, per_page, offset))

            data_users = cur.fetchall()

            return render_template('lihat_data_user.html', username=username, check_pemain_for_user=check_pemain_for_user, check_admin_for_user=check_admin_for_user,  data_users=data_users,  total_pages=total_pages, current_page=page, role=role, per_page=per_page)

    else:
        return redirect('/lihat_data_pemain')


# Fungsi Hapus User
@app.route('/hapus_data_user/<int:id_user>', methods=['POST'])
def hapus_data_user(id_user):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):

        # Lakukan operasi delete di sini, misalnya dengan menggunakan query SQL
        cur.execute(
            "DELETE FROM tbl_users WHERE id_user = %s", (id_user,))
        conn.commit()  # Jangan lupa untuk commit perubahan
        # Tampilkan pesan sukses
        flash('Data User berhasil dihapus', 'success')
        return redirect('/lihat_data_user')
    else:
        flash('Anda tidak memiliki izin untuk menghapus data kriteria',
              'danger')  # Tampilkan pesan error
        return redirect('/lihat_data_user')


# Fungsi untuk mendapatkan data posisi pemain
def get_player_positions():
    cur.execute("SELECT DISTINCT posisi FROM tbl_pemain")
    positions = cur.fetchall()
    return [posisi[0] for posisi in positions]


# Halaman Data Nilai Pemain
@app.route('/data_nilai_pemain', methods=['GET', 'POST'])
def data_nilai_pemain():
    if 'user_id' in session:
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']
            # query
            cur.execute("SELECT p.nisn, p.nama_pemain, k.id_kriteria, nk.nilai "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            table_data = {}

            for row in data_nilai_kriteria:
                nisn = row[0]
                nama_pemain = row[1]
                id_kriteria = row[2]
                nilai = row[3]

                if nisn not in table_data:
                    table_data[nisn] = {
                        'nama_pemain': nama_pemain, 'nisn': nisn}
                table_data[nisn][id_kriteria] = nilai

            cur.execute("SELECT k.id_kriteria, k.nama_kriteria "
                        "FROM tbl_kriteria k "
                        "WHERE k.posisi = %s", (posisi_pemain,))
            kriteria_list = {row[0]: row[1] for row in cur.fetchall()}

            # Pagination
            per_page = 10
            total_pages = math.ceil(len(table_data) / per_page)
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            data_to_display = list(table_data.values())[
                offset: offset + per_page]

            return render_template(
                'data_nilai_pemain.html', username=username,
                table_data=data_to_display,
                kriteria_list=kriteria_list,
                positions=get_player_positions(),
                posisi_pemain=posisi_pemain,
                current_page=page,
                total_pages=total_pages, per_page=page
            )
        else:
            posisi_pemain = request.args.get('posisi_pemain', 'GK')

            # query
            cur.execute("SELECT p.nisn, p.nama_pemain, k.id_kriteria, nk.nilai "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            table_data = {}

            for row in data_nilai_kriteria:
                nisn = row[0]
                nama_pemain = row[1]
                id_kriteria = row[2]
                nilai = row[3]

                if nisn not in table_data:
                    table_data[nisn] = {
                        'nama_pemain': nama_pemain, 'nisn': nisn}
                table_data[nisn][id_kriteria] = nilai

            cur.execute("SELECT k.id_kriteria, k.nama_kriteria "
                        "FROM tbl_kriteria k "
                        "WHERE k.posisi = %s", (posisi_pemain,))
            kriteria_list = {row[0]: row[1] for row in cur.fetchall()}

            # Pagination
            per_page = 10
            total_pages = math.ceil(len(table_data) / per_page)
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            data_to_display = list(table_data.values())[
                offset: offset + per_page]

            return render_template(
                'data_nilai_pemain.html', username=username,
                table_data=data_to_display,
                kriteria_list=kriteria_list,
                positions=get_player_positions(),
                posisi_pemain=posisi_pemain,
                current_page=page,
                total_pages=total_pages, per_page=page
            )

    else:
        return redirect('/login')


# Halaman edit nilai pemain
@app.route('/edit_nilai_pemain/<nisn>', methods=['GET', 'POST'])
def edit_nilai_pemain(nisn):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        # Query data dari tabel tbl_nilai_kriteria untuk nisn tertentu
        cur.execute("SELECT nk.id_kriteria, nk.nilai, k.nama_kriteria "
                    "FROM tbl_nilai_kriteria nk "
                    "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                    "WHERE nk.nisn = %s", (nisn,))
        data_nilai_kriteria = cur.fetchall()

        # Query untuk mendapatkan informasi nama pemain
        cur.execute(
            "SELECT nama_pemain FROM tbl_pemain WHERE nisn = %s", (nisn,))
        nama_pemain = cur.fetchone()[0]

        if request.method == 'POST':
            for row in data_nilai_kriteria:
                kriteria_id = row[0]
                edited_nilai = float(request.form.get(
                    f'edited_nilai_{kriteria_id}', row[1]))

                # Update nilai dalam tabel tbl_nilai_kriteria
                cur.execute("UPDATE tbl_nilai_kriteria SET nilai = %s WHERE nisn = %s AND id_kriteria = %s",
                            (edited_nilai, nisn, kriteria_id))
                conn.commit()

            flash("Nilai berhasil diubah.", "success")
            return redirect('/data_nilai_pemain')

        return render_template('edit_nilai_pemain.html', username=username, nisn=nisn, nama_pemain=nama_pemain, data_nilai_kriteria=data_nilai_kriteria)

    return redirect('/data_nilai_pemain')


# Halaman Delete nilai pemain
@app.route('/hapus_nilai/<nisn>', methods=['GET', 'POST'])
def hapus_nilai(nisn):
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        # Perform the deletion operation here, e.g., using a database query
        cur.execute("DELETE FROM tbl_nilai_kriteria WHERE nisn = %s", (nisn,))
        conn.commit()  # Commit the transaction

        # Flash a success message
        flash('Data berhasil dihapus!', 'success')

        # Redirect back to the data_nilai_pemain
        return redirect('/data_nilai_pemain')
    else:
        return redirect('/login')


# Halaman tambah user oleh admin
@app.route('/tambah_user', methods=['GET', 'POST'])
def add_user():
    if 'user_id' in session and (session['role'] == 'admin' or session['role'] == 'superadmin'):
        user_id = session['user_id']
        username = get_username(user_id)
        if request.method == 'POST':
            username = request.form['username'].lower()
            password = request.form['password']
            role = request.form['role']

            if cek_username(username):
                # Username sudah ada, tampilkan pesan error
                error_message = "Username sudah terdaftar. Silakan pilih username lain."
                return render_template('tambah_user.html', username=username, error_message=error_message)

            # Enkripsi password
            hashed_password = hash_password(password)

            try:
                cur.execute("INSERT INTO tbl_users (username, password, role) VALUES (%s, %s, %s)",
                            (username, hashed_password, role))
                conn.commit()
                # Pendaftaran berhasil
                success = "User berhasil didaftarkan"
                return render_template('tambah_user.html', username=username, success=success)
            except Exception as e:
                # Gagal memasukkan data, tampilkan pesan error
                error_message_db = "Gagal mendaftarkan user. Silakan coba lagi."
                return render_template('tambah_user.html', username=username, error_message_db=error_message_db)

        return render_template('tambah_user.html', username=username)

# Baris untuk routing (end) ========================


# Function Normalisasi matriks
def calculate_sum_of_squared_values(data):
    # membuat dataframe dengan pandas
    df = pd.DataFrame(
        data, columns=['nisn', 'nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

    # Menggunakan pivot untuk membentuk ulang dataframe
    pivot_df = df.pivot(index='nama_pemain',
                        columns='id_kriteria', values='nilai')

    # Buat nama kolom menjadi nama kriteria
    pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

    # Melakukan pengkuadratan untuk setiap nilai kriteria (nilai*nilai)
    for kriteria in pivot_df.columns:
        pivot_df[kriteria] = pivot_df[kriteria] ** 2

    # Buat Dataframe untuk menampung nilai kuadrat setiap nilai kriteria
    sum_df = pd.DataFrame(
        {'kriteria': pivot_df.columns, 'jumlah': pivot_df.sum()})

    # Hitung akar kuadrat dari jumlah nilai setiap kriteria (akar dari kuadrat tiap nilai kriteria)
    sum_df['jumlah'] = sum_df['jumlah'].apply(lambda x: math.sqrt(x))

    # Konversi normalisasi matriks ke dalam bentuk dictionary/kamus
    sum_data = sum_df.to_dict(orient='records')

    return sum_data


# Halaman Hasil MOORA
@app.route('/perhitungan_divisi_akar', methods=['GET', 'POST'])
def perhitungan_divisi_akar():
    # Cek session apakah pengguna sudah login dan memiliki user id
    if 'user_id' in session:
        user_id = session['user_id']
        username = get_username(user_id)
        # Cek posisi yang dipilih untuk melihat hasil moora
        if request.method == 'POST':
            posisi_pemain = request.form['posisi_pemain']

            # Query untuk memilih data sesuai dengan posisi yang dipilih
            # Join table untuk mendapatkan data nilai kriteria
            cur.execute("SELECT p.nisn, p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Gunakan Function normalisasi matriks
            sum_data = calculate_sum_of_squared_values(data_nilai_kriteria)

            # Buat dataframe lalu lakukan perhitungan kuadrat tiap nilai kriteria
            pivot_df_squared = create_pivot_df(
                data_nilai_kriteria, squared=True)

            # Buat Dataframe untuk pengakaran
            pivot_df_divisi_akar = create_pivot_df_divisi_akar(
                pivot_df_squared, sum_data, posisi_pemain, cur)

            # konversi nilai dari pengakaran ke decimal.Decimal
            pivot_df_divisi_akar = pivot_df_divisi_akar.applymap(
                decimal.Decimal)

            # Ambil tipe kriteria (benefit atau cost) dari tbl_kriteria berdasarkan posisi
            cur.execute(
                "SELECT nama_kriteria, tipe FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
            criteria_types = dict(cur.fetchall())

            # Menghitung total nilai bertipe benefit dan cost untuk setiap pemain
            pivot_df_divisi_akar['Total Benefit'] = decimal.Decimal(0.0)
            pivot_df_divisi_akar['Total Cost'] = decimal.Decimal(0.0)

            # perulangan untuk menjumlahkan tiap kriteria benefit dan cost
            for kriteria in pivot_df_divisi_akar.columns:
                nilai_kriteria = pivot_df_divisi_akar[kriteria]
                tipe_kriteria = criteria_types.get(kriteria)

                if tipe_kriteria == 'benefit':
                    pivot_df_divisi_akar['Total Benefit'] += nilai_kriteria
                elif tipe_kriteria == 'cost':
                    pivot_df_divisi_akar['Total Cost'] += nilai_kriteria

            # menghitung nilai optimasi dengan mengurangkan jumlah nilai benefit dikurang jumlah nilai cost
            # \ adalah line continuation character.
            pivot_df_divisi_akar['Nilai Moora'] = pivot_df_divisi_akar['Total Benefit'] - \
                pivot_df_divisi_akar['Total Cost']

            # Konversi nilai kedalam dictionary, table_data adalah hasil moora
            table_data = pivot_df_divisi_akar.reset_index().to_dict(orient='records')
            table_data.sort(key=lambda x: x['Nilai Moora'], reverse=True) #mengurutkan peringkat dari nilai terbesar

            # Pagination
            per_page = 10
            total_pages = math.ceil(len(table_data) / per_page)
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            data_to_display = table_data[offset: offset + per_page]

            return render_template('perhitungan_divisi_akar.html', username=username, table_data=data_to_display,
                                   criteria=pivot_df_divisi_akar.columns, positions=get_player_positions(), posisi_pemain=posisi_pemain,
                                   current_page=page, total_pages=total_pages, per_page=per_page)
        else:
            posisi_pemain = request.args.get('posisi_pemain', 'GK')

            # Query untuk memilih data sesuai dengan posisi yang dipilih
            # Join table untuk mendapatkan data nilai kriteria
            cur.execute("SELECT p.nisn, p.nama_pemain, k.nama_kriteria, nk.nilai, k.id_kriteria "
                        "FROM tbl_nilai_kriteria nk "
                        "JOIN tbl_pemain p ON nk.nisn = p.nisn "
                        "JOIN tbl_kriteria k ON nk.id_kriteria = k.id_kriteria "
                        "WHERE p.posisi = %s", (posisi_pemain,))
            data_nilai_kriteria = cur.fetchall()

            # Gunakan Function normalisasi matriks
            sum_data = calculate_sum_of_squared_values(data_nilai_kriteria)

            # Buat dataframe lalu lakukan perhitungan kuadrat tiap nilai kriteria
            pivot_df_squared = create_pivot_df(
                data_nilai_kriteria, squared=True)

            # Buat Dataframe untuk pengakaran
            pivot_df_divisi_akar = create_pivot_df_divisi_akar(
                pivot_df_squared, sum_data, posisi_pemain, cur)

            # konversi nilai dari pengakaran ke decimal.Decimal
            pivot_df_divisi_akar = pivot_df_divisi_akar.applymap(
                decimal.Decimal)

            # Ambil tipe kriteria (benefit atau cost) dari tbl_kriteria berdasarkan posisi
            cur.execute(
                "SELECT nama_kriteria, tipe FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
            criteria_types = dict(cur.fetchall())

            # Menghitung total nilai bertipe benefit dan cost untuk setiap pemain
            pivot_df_divisi_akar['Total Benefit'] = decimal.Decimal(0.0)
            pivot_df_divisi_akar['Total Cost'] = decimal.Decimal(0.0)

            # perulangan untuk menjumlahkan tiap kriteria benefit dan cost
            for kriteria in pivot_df_divisi_akar.columns:
                nilai_kriteria = pivot_df_divisi_akar[kriteria]
                tipe_kriteria = criteria_types.get(kriteria)

                if tipe_kriteria == 'benefit':
                    pivot_df_divisi_akar['Total Benefit'] += nilai_kriteria
                elif tipe_kriteria == 'cost':
                    pivot_df_divisi_akar['Total Cost'] += nilai_kriteria

            # menghitung nilai optimasi dengan mengurangkan jumlah nilai benefit dikurang jumlah nilai cost
            # \ adalah line continuation character.
            pivot_df_divisi_akar['Nilai Moora'] = pivot_df_divisi_akar['Total Benefit'] - \
                pivot_df_divisi_akar['Total Cost']

            # Konversi nilai kedalam dictionary, table_data adalah hasil moora
            table_data = pivot_df_divisi_akar.reset_index().to_dict(orient='records')
            table_data.sort(key=lambda x: x['Nilai Moora'], reverse=True)

            # Pagination
            per_page = 10
            total_pages = math.ceil(len(table_data) / per_page)
            page = request.args.get('page', 1, type=int)
            offset = (page - 1) * per_page

            data_to_display = table_data[offset: offset + per_page]

           
            return render_template('perhitungan_divisi_akar.html', username=username, table_data=data_to_display,
                                   criteria=pivot_df_divisi_akar.columns, positions=get_player_positions(), posisi_pemain=posisi_pemain,
                                   current_page=page, total_pages=total_pages, per_page=per_page)

    else:
        return redirect('/login')

# Fungsi untuk menyimpan data hasil kuadrat (jika nilai true)
def create_pivot_df(data, squared=False):
    # membuat dataframe
    df = pd.DataFrame(
        data, columns=['nisn', 'nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

    # Menggunakan pivot untuk membentuk ulang dataframe
    pivot_df = df.pivot(index=['nisn', 'nama_pemain'],
                        columns='id_kriteria', values='nilai')

    # Buat nama kolom menjadi nama kriteria
    pivot_df.columns = [kriteria for kriteria in df['nama_kriteria'].unique()]

    if squared:
        # melakukan perulangan untuk mengkuadratkan setiap nilai kriteria
        for kriteria in pivot_df.columns:
            pivot_df[kriteria] = pivot_df[kriteria] ** 2

    return pivot_df

# Fungsi untuk menghitung normalisasi matriks terbobot
def create_pivot_df_divisi_akar(pivot_df_squared, sum_data, posisi_pemain, cur):
    # Buat Dataframe sesuai dengan normalisasi matriks
    pivot_df_divisi_akar = pivot_df_squared.copy()

    # mengambil bobot dari tbl_kriteria berdasarkan posisi pemain
    cur.execute(
        "SELECT nama_kriteria, bobot FROM tbl_kriteria WHERE posisi = %s", (posisi_pemain,))
    kriteria_weights = dict(cur.fetchall())

    # Lakukan perhitungan (nilai / akar_jumlah_pemangkatan) * bobot tiap kriteria
    for kriteria in pivot_df_divisi_akar.columns:
        sum_value = next(
            (item['jumlah'] for item in sum_data if item['kriteria'] == kriteria), None)
        
        sum_value_decimal = decimal.Decimal(sum_value)
        
        bobot = decimal.Decimal(kriteria_weights.get(kriteria, 1.0))
        pivot_df_divisi_akar[kriteria] = (
            np.sqrt(pivot_df_divisi_akar[kriteria]) / sum_value_decimal) * bobot

    return pivot_df_divisi_akar

# Halaman Ubah Password
@app.route('/change_password', methods=['GET', 'POST'])
def change_password():
    if 'user_id' not in session:
        return redirect('/login')

    if request.method == 'POST':
        user_id = session['user_id']
        current_password = request.form['current_password']
        new_password = request.form['new_password']
        confirm_password = request.form['confirm_password']

        # mengambil hash password user dari database
        cur.execute(
            "SELECT password FROM tbl_users WHERE id_user = %s", (user_id,))
        current_hashed_password = cur.fetchone()[0]

        # Periksa apakah kata sandi saat ini cocok dengan kata sandi hash yang disimpan
        if hashlib.sha256(current_password.encode('utf-8')).hexdigest() != current_hashed_password:
            error = 'Password saat ini salah'
            return render_template('change_password.html', error=error)

        # cek apakah password baru dan konfirmasi password baru sama
        if new_password != confirm_password:
            error = 'password baru dan konfirmasi password tidak sesuai'
            return render_template('change_password.html', error=error)

        # lakukan hash password
        hashed_new_password = hashlib.sha256(
            new_password.encode('utf-8')).hexdigest()

        # Update password user pada database
        cur.execute("UPDATE tbl_users SET password = %s WHERE id_user = %s",
                    (hashed_new_password, user_id))
        conn.commit()

        success = 'Password Berhasil diubah'
        return render_template('change_password.html', success=success)

    return render_template('change_password.html')

# Halaman Untuk cek perhitungan
"""
# Halaman perhitungan_akar_jumlah_pemangkatan
@app.route('/perhitungan_akar_jumlah_pemangkatan', methods=['GET', 'POST'])
def perhitungan_akar_jumlah_pemangkatan():
    if 'user_id' in session:
        user_id = session['user_id']
        username = get_username(user_id)
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

            return render_template('perhitungan_akar_jumlah_pemangkatan.html', username=username, sum_data=sum_data,
                                   positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('perhitungan_akar_jumlah_pemangkatan.html', username=username, positions=get_player_positions())
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
            df = pd.DataFrame(data_nilai_kriteria, columns=[
                              'nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

            # Use pivot to reshape the DataFrame
            pivot_df = df.pivot(index='nama_pemain',
                                columns='id_kriteria', values='nilai')

            # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
            pivot_df.columns = [
                kriteria for kriteria in df['nama_kriteria'].unique()]

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
            df = pd.DataFrame(data_nilai_kriteria, columns=[
                              'nama_pemain', 'nama_kriteria', 'nilai', 'id_kriteria'])

            # Use pivot to reshape the DataFrame
            pivot_df = df.pivot(index='nama_pemain',
                                columns='id_kriteria', values='nilai')

            # Reset the column names to use "nama_kriteria" instead of "id_kriteria"
            pivot_df.columns = [
                kriteria for kriteria in df['nama_kriteria'].unique()]

            # Perform the calculation: nilai * nilai for each criterion
            for kriteria in pivot_df.columns:
                pivot_df[kriteria] = pivot_df[kriteria] ** 2

            # Create a new DataFrame to hold the sum of the squared values for each criterion
            sum_df = pd.DataFrame(
                {'kriteria': pivot_df.columns, 'jumlah': pivot_df.sum()})

            # Convert the sum DataFrame to a list of dictionaries
            sum_data = sum_df.to_dict(orient='records')

            return render_template('perhitungan_jumlah_pemangkatan.html', sum_data=sum_data,
                                   positions=get_player_positions(), posisi_pemain=posisi_pemain)

        return render_template('perhitungan_jumlah_pemangkatan.html', positions=get_player_positions())
    else:
        return redirect('/login')
"""

if __name__ == '__main__':
    app.run(debug=True)
