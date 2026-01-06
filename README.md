# Netflix Movies and TV Shows Analysis Using SQL

Project ini bertujuan untuk menganalisis dataset Netflix menggunakan SQL yang berguna untuk memperoleh insight mengenai jenis konten, distribusi tahun rilis, rating, dan negara asal yang diperoleh dari kaggle

## Project Overview
Project ini merupakan analisis eksploratif terhadap dataset Netflix Movies and TV Shows menggunakan SQL. 
Analisis difokuskan pada distribusi konten, tren rilis, genre, aktor, negara produksi, serta indikasi konten kekerasan untuk memperoleh insight yang relevan dari sudut pandang bisnis dan data.


## Dataset
Dataset yang digunakan adalah dataset Netflix Movies and TV Shows yang berisi informasi mengenai film dan acara TV yang tersedia di Netflix.

## Tools
- PostgreSQL
- SQL (psql / pgAdmin)
- Dataset CSV

## Business Problems and Analysis

### 1. Perbandingan Jumlah Movie dan TV Show

```sql
SELECT 
    type,
    COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

**Tujuan:**  
Menghitung dan membandingkan jumlah konten Movie dan TV Show di Netflix.

**Hasil:**  
- Movie: 6.131  
- TV Show: 2.676  

**Analisis:**  
Jumlah Movie lebih banyak dibandingkan TV Show, yang menunjukkan bahwa katalog Netflix didominasi oleh konten film.

### 2. Menentukan Rating yang Paling Umum pada Film dan Acara TV

```sql
select
    type,
    rating
from
    (
        select
            type,
            rating,
            count(*), --menghitung jumlah konten untuk tiap kombinasi
            --Data dibagi menjadi 2 dan direset untuk tiap type(window function)
            rank() over (
                partition by type
                order by count(*) desc
            ) as rangking
        from netflix
        group by 1,2
    ) as t1 --alias untuk subquery
where
    rangking = 1;
```

**Tujuan:**  
Menentukan rating konten yang paling umum untuk masing-masing jenis konten, yaitu Movie dan TV Show, guna memahami preferensi klasifikasi usia pada katalog Netflix.

**Hasil:**  
- Movie: TV-MA
- TV Show: TV-MA

**Analisis:**  
Hasil analisis menunjukkan bahwa rating TV-MA (Mature Audience) merupakan rating yang paling dominan baik pada film maupun acara TV di Netflix. Hal ini mengindikasikan bahwa sebagian besar konten Netflix ditujukan untuk penonton dewasa, dengan tema yang lebih kompleks dan tidak cocok untuk anak-anak.

### 3.Menampilkan seluruh film yang dirilis pada tahun tertentu
```sql
select
    *
from
    netflix
where
    type = 'Movie'
    and release_year = 2021;
```
**Tujuan:**  
Menampilkan seluruh konten film (Movie) yang dirilis pada tahun 2021 untuk mengetahui daftar film yang tersedia di Netflix pada tahun tersebut.

**Hasil:**  
Menghasilkan daftar film yang dirilis pada tahun 2021 beserta informasi lengkapnya

### 4.Menentukan 5 negara dengan jumlah konten terbanyak di Netflix
```sql
SELECT 
    unnest(string_to_array(country, ', ')) AS country,
    -- string_to_array: memecah string berdasarkan delimiter (', ')
    -- unnest: mengubah array menjadi baris
    count (show_id) AS total_content
FROM
    netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Tujuan:**  
Mengidentifikasi lima negara dengan jumlah konten terbanyak di Netflix untuk mengetahui negara yang paling dominan 

**Hasil:**  
Lima negara dengan jumlah konten terbanyak adalah:
- United States: 3.689
- India: 1.046
- United Kingdom: 804
- Canada: 445
- France: 393

**Analisis:**  
Hasil menunjukkan bahwa Amerika Serikat mendominasi jumlah konten di Netflix, diikuti oleh India dan Inggris.

### 5.Mengidentifikasikan movie terpanjang
```sql
SELECT
    *
FROM
    netflix
WHERE
    type = 'Movie'
    and duration =(
        select
            max(duration)
        from
            netflix
    );
```

**Tujuan:**  
Mengidentifikasi movie dengan durasi terpanjang yang tersedia di Netflix untuk mengetahui konten movie dengan waktu tayang paling lama.

**Hasil:**  
Query ini menampilkan Movie yang memiliki nilai durasi paling besar dibandingkan lainnya dalam dataset Netflix.


### 6.Mengidentifikasi konten yang ditambahkan ke Netflix dalam lima tahun terakhir
```sql
SELECT
    show_id,
    type,
    title,
    date_added
FROM
    netflix
WHERE
    date_added IS NOT NULL
    AND (
        CASE
            WHEN date_added ~ '^[0-9]{2}-[A-Za-z]{3}-[0-9]{2}$' THEN to_date(date_added, 'DD-Mon-YY')
            WHEN date_added ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$' THEN to_date(date_added, 'Month DD, YYYY')
        END
    ) >= current_date - INTERVAL '5 years';
```

**Tujuan:**  
Mengetahui konten Netflix yang ditambahkan dalam lima tahun terakhir berdasarkan tanggal penambahan (date_added)

**Hasil:**  
Query ini menghasilkan daftar konten Netflix yang ditambahkan dalam lima tahun terakhir sejak waktu eksekusi query.


### 7.Menemukan semua movies / TV shows yang memiliki director oleh 'Rajiv chilaka'
```sql
SELECT
    *
FROM
    netflix
WHERE
    director ILIKE '%Rajiv Chilaka%';--ILIKE: case insensitive dan menggunakan wildcard % untuk pencarian parsial agar menemukan semua variasi nama yang mengandung 'Rajiv Chilaka'	
```

**Tujuan:**  
Mengidentifikasi seluruh Movie dan TV Show di Netflix yang disutradarai oleh Rajiv Chilaka.

**Hasil:**  
Query ini menghasilkan daftar film dan acara TV yang memiliki Rajiv Chilaka sebagai sutradara, baik sebagai sutradara tunggal maupun sebagai bagian dari kolaborasi dengan sutradara lain.

### 8.Mengidentifikasi TV show yang memiliki lebih dari lima season
```sql
SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5
```
**Tujuan:**  
Mengetahui daftar acara TV (TV Show) di Netflix yang memiliki jumlah season lebih dari lima.

**Hasil:**  
Query ini menampilkan daftar TV Show yang memiliki lebih dari lima season, berdasarkan informasi jumlah season yang terdapat pada kolom duration.

### 9.Menghitung distribusi jumlah konten pada masing-masing genre
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
    COUNT(show_id) as total_content
FROM
    netflix
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT 5;
```
**Tujuan:**  
Mengidentifikasi lima genre dengan jumlah konten terbanyak di Netflix untuk mengetahui genre yang paling dominan dalam katalog Netflix.

**Hasil:**  
| Genre                | total_content |
| -------------------- | ------------- |
| International Movies | 2.624         |
| Dramas               | 1.600         |
| Comedies             | 1.210         |
| Action & Adventure   | 859           |
| Documentaries        | 829           |


**Analisis**

Hasil analisis menunjukkan bahwa International Movies merupakan genre dengan jumlah konten terbanyak di Netflix, diikuti oleh Dramas dan Comedies.

### 10.Menganalisis rata-rata jumlah konten yang dirilis India per tahun di Netflix dan mengidentifikasi lima tahun dengan rata-rata tertinggi
```sql
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5
```
**Tujuan:**  
Mengetahui jumlah konten yang dirilis oleh India di Netflix setiap tahun dan menampilkan 5 tahun dengan kontribusi rilis terbesar.

**Hasil:**  
| country | release_year | total_release | avg_release |
| ------- | ------------ | ------------- | ----------- |
| India   | 2017         | 101           | 10.39       |
| India   | 2018         | 94            | 9.67        |
| India   | 2019         | 87            | 8.95        |
| India   | 2020         | 75            | 7.72        |
| India   | 2016         | 73            | 7.51        |

**Analisis**

Hasil menunjukkan bahwa tahun 2017 menjadi tahun paling produktif dengan 101 konten (10,39% dari total), diikuti 2018–2020 dengan jumlah rilis menurun secara bertahap. Tahun 2016 juga cukup tinggi


### 11.Menyebutkan semua film yang bergenre dokumenter
```sql
SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%'
```

**Tujuan:**  
Menampilkan seluruh konten film di Netflix yang memiliki genre dokumenter dengan memfilter kolom listed_in yang mengandung kata Documentaries.

**Hasil:** 
Menghasilkan daftar film yang dikategorikan sebagai dokumenter beserta seluruh atributnya 

### 12.Menemukan semua konten yang tidak memiliki sutradara(director)
```sql
SELECT
    *
FROM
    netflix
WHERE
    director IS NULL
```
**Tujuan:**  
Menemukan semua konten di Netflix yang tidak memiliki sutradara. Dengan memfilter kolom director yang bernilai NULL, kita bisa mengidentifikasi konten yang informasinya belum lengkap terkait sutradara.

**Hasil:**  
Menampilkan semua baris konten di mana kolom director kosong (NULL). Data ini menunjukkan konten-konten yang tidak tercatat sutradaranya.

### 13.Mencari berapa banyak film yang dibintangi aktor 'Salman Khan' dalam 10 tahun terakhir
```sql
SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```
**Tujuan**
Menemukan semua Movie atau TV show yang dibintangi oleh Salman Khan dalam 10 tahun terakhir dengan memfilter berdasarkan kolom casts dan release_year

**Hasil:**  
Menampilkan semua baris konten yang memenuhi kriteria, yaitu film yang menampilkan Salman Khan dan dirilis setelah 10 tahun terakhir


### 14.Memukan 5 aktor teratas yang telah tampil dalam jumlah film terbanyak yang diproduksi di India
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```
**Tujuan**
Mengidentifikasi aktor yang paling sering muncul dalam konten Netflix asal India. Dengan memecah kolom casts menjadi nama aktor satu per satu dan menghitung frekuensi kemunculannya

**Hasil:**  
| Actor          | Count             |
| -------------- | ----------------- |
| Anupam Kher    | 36                |
| Paresh Rawal   | 24                |
| Shah Rukh Khan | 24                |
| Om Puri        | 23                |
| Akshay Kumar   | 22                |


**Analisis**
Dari hasil tersebut dapat disimpulkan bahwa Anupam Kher merupakan aktor yang paling dominan dalam konten Netflix India.

### 15.Kategorikan konten berdasarkan keberadaan kata kunci 'kill' dan 'violence' di kolom deskripsi. Beri label konten yang mengandung kata kunci ini sebagai 'Bad' dan semua konten lainnya sebagai 'Good'. Hitung berapa banyak item yang termasuk dalam setiap kategori.
```sql
SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2
```
**Tujuan**

Query ini bertujuan untuk mengelompokkan konten Netflix berdasarkan tingkat kekerasan dalam deskripsi dengan mendeteksi keberadaan kata kunci “kill” dan “violence”. Konten yang mengandung kata kunci tersebut diberi label “Bad”, sedangkan konten lainnya diberi label “Good”, lalu dihitung jumlahnya untuk setiap jenis konten (Movie dan TV Show).

**Hasil**
| Category | Type        | Content_count |
| -------- | ----------- | ------------- |
| Bad      | Movie       | 251           |
| Good     | Movie       | 5880          |
| Bad      | TV Show     | 91            |
| Good     | TV Show     | 2585          |


**Analisis**
Disimpulkan bahwa konten Netflix didominasi oleh kategori “Good”, baik pada Movie maupun TV Show. Jumlah konten “Bad” relatif kecil, yang mengindikasikan bahwa deskripsi konten dengan kata kunci kekerasan tidak terlalu banyak muncul.










