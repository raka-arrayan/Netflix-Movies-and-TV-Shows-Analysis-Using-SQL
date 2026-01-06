# Netflix Dataset (Column Description & Rating Reference)

Dokumen ini berisi penjelasan setiap kolom pada dataset Netflix Movies and TV Shows
serta penjelasan sistem rating konten yang digunakan.

---

## Dataset Overview
Dataset ini berisi informasi mengenai film dan acara TV yang tersedia di Netflix,
termasuk jenis konten, tahun rilis, rating usia, durasi, dan deskripsi.

---

## Column Description

### 1. `show_id`
ID unik untuk setiap konten di Netflix.

---

### 2. `type`
Jenis konten yang tersedia di Netflix.
- **Movie**
- **TV Show**

---

### 3. `title`
Judul film atau acara TV.

---

### 4. `director`
Nama sutradara dari konten tersebut.  
Kolom ini dapat bernilai kosong (NULL) jika data tidak tersedia.

---

### 5. `cast`
Daftar pemeran utama dalam film atau acara TV.

---

### 6. `country`
Negara asal produksi konten.  
Satu konten dapat berasal dari lebih dari satu negara.

---

### 7. `date_added`
Tanggal konten ditambahkan ke platform Netflix.

---

### 8. `release_year`
Tahun rilis pertama konten tersebut.

---

### 9. `rating`
Klasifikasi usia penonton berdasarkan standar rating film dan televisi.

---

### 10. `duration`
Durasi konten:
- Movie : durasi dalam menit (contoh: `90 min`)
- TV Show : jumlah season (contoh: `2 Seasons`)

---

### 11. `listed_in`
Genre atau kategori konten, seperti:
- Drama
- Comedy
- Documentary
- dll

---

### 12. `description`
Deskripsi singkat mengenai alur cerita atau isi konten.

---

## TV Content Ratings

| Rating | Full Name | Description |
|------|----------|------------|
| TV-MA | Television Mature Audience | Konten untuk penonton dewasa |
| TV-14 | Television – Parents Strongly Cautioned | Usia 14 tahun ke atas |
| TV-PG | Television – Parental Guidance Suggested | Perlu bimbingan orang tua |
| TV-G | Television – General Audience | Semua umur |
| TV-Y | Television – Youth | Konten anak-anak |
| TV-Y7 | Television – Youth (7+) | Anak usia 7 tahun ke atas |
| TV-Y7-FV | Television – Youth (Fantasy Violence) | Kekerasan fantasi untuk anak 7+ |

---

## Movie Ratings (MPA)

| Rating | Full Name | Description |
|------|----------|------------|
| G | General Audiences | Semua umur |
| PG | Parental Guidance Suggested | Bimbingan orang tua |
| PG-13 | Parents Strongly Cautioned | Usia 13 tahun ke atas |
| R | Restricted | Usia 17+ dengan pendamping |
| NC-17 | No One 17 and Under Admitted | Dewasa saja |

---

## Special Ratings

| Rating | Full Name | Description |
|------|----------|------------|
| NR | Not Rated | Konten tidak memiliki rating |
| UR | Unrated | Versi tanpa rating resmi |

---

## Notes on Data Quality
Dataset Netflix memiliki beberapa inkonsistensi data, seperti:
- Nilai durasi yang muncul pada kolom `rating`
- Nilai kosong (NULL) pada kolom `director` dan `cast`

---
