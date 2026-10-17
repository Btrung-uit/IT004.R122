USE QuanLyBanHang
GO

-- III. Ngôn ngữ truy vấn dữ liệu:

-- Câu 1: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

-- Câu 2: In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT in ('cay', 'quyen')

-- Câu 3: In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%01'

-- Câu 4: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN	30000 AND 40000

-- Câu 5: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX IN ('Trung Quoc', 'Thai Lan') AND GIA BETWEEN 30000 AND 40000

-- Câu 6: In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD = '2007-01-01' OR NGHD = '2007-01-02'

-- Câu 7: In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD >= '2007-01-01' AND NGHD < '2007-02-01'
ORDER BY NGHD ASC, TRIGIA DESC

-- Câu 8: In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007. 
SELECT DISTINCT KH.MAKH, KH.HOTEN
FROM KHACHHANG AS KH
JOIN HOADON AS HD
	ON KH.MAKH = HD.MAKH
WHERE HD.NGHD = '2007-01-01'

-- Câu 9: In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT HD.SOHD, HD.TRIGIA
FROM HOADON AS HD
JOIN NHANVIEN AS NV
	ON HD.MANV = NV.MANV
WHERE NV.HOTEN = 'Nguyen Van B' AND HD.NGHD = '2006-10-28'

-- Câu 10: In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006. 
SELECT DISTINCT SP.MASP, SP.TENSP -- DISTINCT dùng để bỏ các dòng dữ liệu trùng lặp
FROM KHACHHANG AS KH
JOIN HOADON AS HD
	ON KH.MAKH = HD.MAKH
JOIN CTHD AS CT
	ON HD.SOHD = CT.SOHD
JOIN SANPHAM AS SP
	ON CT.MASP = SP.MASP
WHERE KH.HOTEN = 'Nguyen Van A'
	AND NGHD >= '2006-10-01'
	AND NGHD < '2006-11-01'

-- Câu 11: Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT DISTINCT SOHD
FROM CTHD
WHERE MASP IN ('BB01', 'BB02')

-- Câu 12: Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT DISTINCT SOHD
FROM CTHD
WHERE MASP IN ('BB01', 'BB02')
	AND SL BETWEEN 10 AND 20

-- Câu 13: Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE MASP IN ('BB01', 'BB02')
	AND SL BETWEEN 10 AND 20
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) = 2

-- Câu 14: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

UNION

SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP
JOIN CTHD AS CT
	ON SP.MASP = CT.MASP
JOIN HOADON AS HD
	ON CT.SOHD = HD.SOHD
WHERE HD.NGHD = '2007-01-01'

-- Câu 15: In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP
LEFT JOIN CTHD AS CT
	ON SP.MASP = CT.MASP
WHERE CT.MASP IS NULL

-- Câu 16: In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP
WHERE NOT EXISTS
(
	SELECT 1
	FROM CTHD AS CT
	JOIN HOADON AS HD
		ON CT.SOHD = HD.SOHD
	WHERE CT.MASP = SP.MASP
		AND HD.NGHD >= '2006-01-01'
		AND HD.NGHD < '2007-01-01'
)

-- Câu 17: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP
WHERE SP.NUOCSX = 'Trung Quoc' AND NOT EXISTS
(
	SELECT 1
	FROM CTHD AS CT
	JOIN HOADON AS HD
		ON CT.SOHD = HD.SOHD
	WHERE CT.MASP = SP.MASP
		AND HD.NGHD >= '2006-01-01'
		AND HD.NGHD < '2007-01-01'
)