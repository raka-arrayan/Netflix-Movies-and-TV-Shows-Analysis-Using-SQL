---- Netflix Data Analysis using SQL
DROP TABLE IF EXISTS netflix;

create table netflix (
    show_id varchar(6),
    type varchar(10),
    title varchar(150),
    director varchar(208),
    casts varchar(1000),
    country varchar(150),
    date_added varchar(50),
    release_year int,
    rating varchar(10),
    duration varchar(15),
    listed_in varchar(100),
    description varchar(250)
);

select
    *
from
    netflix;

-- menghitung jumlah baris (record) di tabel netflix
select
    count(*) as table_content
from
    netflix;

-- melihat nilai unik (tidak duplikat) yang ada di kolom type
select
    distinct type
from
    netflix;



--1.Menghitung jumlah movie dibandingkan dengan TV show
SELECT
    type,
    COUNT (*) AS total_content
FROM
    netflix
GROUP BY
    type;

-- 2.Menentukan rating yang PALING UMUM (terbanyak) untuk setiap jenis konten (Movie dan TV Show).
select
    type,
    rating
from
    (
        select
            type,
            rating,
            count(*),
            --menghitung jumlah konten untuk tiap kombinasi
            --Data dibagi menjadi 2 dan direset untuk tiap type(window function)
            rank() over (
                partition by type
                order by
                    count(*) desc
            ) as rangking
        from
            netflix
        group by
            1,
            2
    ) as t1 --alias untuk subquery
where
    rangking = 1;

--3.Menampilkan seluruh film yang dirilis pada tahun tertentu
select
    *
from
    netflix
where4.Menentukan 5 negara dengan jumlah konten terbanyak di Netflix
    type = 'Movie'
    and release_year = 2020;

--
SELECT
    unnest(string_to_array(country, ', ')) AS country -- string_to_array: memecah string berdasarkan delimiter (', ')
    -- unnest: mengubah array menjadi baris
    count (show_id) AS total_content
FROM
    netflix
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT
    5;

--5.Mengidentifikasikan movie terpanjang
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

--6.Mengidentifikasi konten yang ditambahkan ke Netflix dalam lima tahun terakhir
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

--7.Menemukan semua movies / TV shows yang memiliki director oleh 'Rajiv chilaka'
SELECT
    *
FROM
    netflix
WHERE
    director ILIKE '%Rajiv Chilaka%';--ILIKE: case insensitive dan menggunakan wildcard % untuk pencarian parsial agar menemukan semua variasi nama yang mengandung 'Rajiv Chilaka'


--8.Mengidentifikasi TV show yang memiliki lebih dari lima season
SELECT
    *
FROM
    netflix
WHERE
    TYPE = 'TV Show'
    AND SPLIT_PART(duration, ' ', 1) :: INT > 5 --::int >5 mengubah string menjadi integer menjadi angka untuk perbandingan


--9.Menghitung distribusi jumlah konten pada masing-masing genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
    COUNT(show_id) as total_content
FROM
    netflix
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT
    5;

--10.Cari tahu rata-rata jumlah konten yang dirilis oleh India di Netflix setiap tahunnya, lalu tampilkan 5 tahun dengan rata-rata rilis konten tertinggi.
SELECT
    country,
    release_year,
    COUNT(show_id) as total_release,
    ROUND(
        COUNT(show_id) :: numeric / (
            SELECT
                COUNT(show_id)
            FROM
                netflix
            WHERE
                country = 'India'
        ) :: numeric * 100,
        2
    ) as avg_release
FROM
    netflix
WHERE
    country = 'India'
GROUP BY
    country,
    2
ORDER BY
    avg_release DESC
LIMIT
    5 


--11.Menyebutkan semua film yang bergenre dokumenter
SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%'

--12.Menemukan semua konten yang tidak memiliki sutradara(director)
SELECT
    *
FROM
    netflix
WHERE
    director IS NULL


--13.Mencari berapa banyak film yang dibintangi aktor 'Salman Khan' dalam 10 tahun terakhir
SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


--14.Memukan 5 aktor teratas yang telah tampil dalam jumlah film terbanyak yang diproduksi di India
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15.Kategorikan konten berdasarkan keberadaan kata kunci 'kill' dan 'violence' di kolom deskripsi. Beri label konten yang mengandung kata kunci ini sebagai 'Bad' dan semua konten lainnya sebagai 'Good'. Hitung berapa banyak item yang termasuk dalam setiap kategori.
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