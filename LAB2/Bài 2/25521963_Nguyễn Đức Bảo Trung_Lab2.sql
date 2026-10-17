USE QuanLyGiaoVu
GO

-- III. Ngôn ngữ truy vấn dữ liệu:

-- Câu 1: In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HV.HO, HV.TEN, HV.NGSINH, HV.MALOP
FROM LOP AS L
JOIN HOCVIEN AS HV
 ON L.TRGLOP = HV.MAHV;

 -- Câu 2: In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
 SELECT HV.MAHV, HV.HO, HV.TEN, KQ.LANTHI, KQ.DIEM
 FROM HOCVIEN AS HV
 JOIN KETQUATHI AS KQ
	ON HV.MAHV = KQ.MAHV
WHERE HV.MALOP = 'K12'
	AND KQ.MAMH = 'Cau Truc Roi Rac'
ORDER BY HV.TEN ASC, HV.HO ASC;

-- Câu 3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HV.MAHV, HV.HO, HV.TEN, MH.MAMH, MH.TENMH
FROM HOCVIEN AS HV
JOIN KETQUATHI AS KQ
	ON HV.MAHV = KQ.MAHV
JOIN MONHOC AS MH
	ON KQ.MAMH =MH.MAMH
WHERE KQ.LANTHI = 1 AND KQ.KQUA = 'Dat';

-- Câu 4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN AS HV
JOIN KETQUATHI AS KQ
	ON HV.MAHV = KQ.MAHV
JOIN MONHOC AS MH
	ON KQ.MAMH =MH.MAMH
WHERE HV.MALOP = 'K11' AND KQ.MAMH = 'Cau Truc Roi Rac' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong Dat';

-- Câu 5: Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT HV.MAHV,  HV.HO, HV.TEN
FROM HOCVIEN AS HV
WHERE HV.MALOP LIKE 'K%'
	AND EXISTS (
	SELECT 1
	FROM KETQUATHI AS KQ
	WHERE KQ.MAHV = HV.MAHV
		AND KQ.MAMH = 'Cau Truc Roi Rac'
)
AND NOT EXISTS (
	SELECT 1
	FROM KETQUATHI AS KQ
	WHERE KQ.MAHV = HV.MAHV
		AND KQ.MAMH = 'Cau Truc Roi Rac'
		AND KQ.KQUA = 'Dat'
);

-- Câu 6: Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006. 
SELECT DISTINCT MH.TENMH
FROM GIAOVIEN AS GV
JOIN GIANGDAY AS GD
	ON GV.MAGV = GD.MAGV
JOIN MONHOC AS MH
	ON GD.MAMH = MH.MAMH
WHERE GV.HOTEN = 'Tran Tam Thanh'
	AND GD.HOCKY = 1
	AND GD.NAM = 2006;

-- Câu 7: Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT DISTINCT MH.MAMH, MH.TENMH
FROM LOP AS L
JOIN GIANGDAY AS GD
	ON L.MAGVCN = GD.MAGV
JOIN MONHOC AS MH
	ON GD.MAMH = MH.MAMH
WHERE L.MALOP = 'K11'
	AND GD.MAGV = L.MAGVCN
	AND GD.HOCKY = 1
	AND GD.NAM = 2006;

-- Câu 8: Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HV.HO, HV.TEN
FROM GIAOVIEN AS GV
JOIN GIANGDAY AS GD
	ON GV.MAGV = GD.MAGV
JOIN MONHOC AS MH
	ON GD.MAMH = MH.MAMH
JOIN LOP AS L
	ON GD.MALOP = L.MALOP
JOIN HOCVIEN AS HV
	ON L.TRGLOP = HV.MAHV
WHERE GV.HOTEN = 'Nguyen To Lan'
AND MH.TENMH = 'Co So Du Lieu';

-- Câu 9: In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MH.MAMH, MH.TENMH
FROM DIEUKIEN AS DK
JOIN MONHOC AS MH
	ON DK.MAMH_TRUOC = MH.MAMH
WHERE DK.MAMH = 'Co So Du Lieu'

-- Câu 10: Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MH.MAMH, MH.TENMH
FROM DIEUKIEN AS DK
JOIN MONHOC AS MH
	ON DK.MAMH = MH.MAMH
WHERE DK.MAMH_TRUOC = 'Cau Truc Roi Rac'

-- Câu 11: Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN AS GV
JOIN GIANGDAY AS GD
	ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'Cau Truc Roi Rac'
	AND GD.HOCKY = 1
	AND GD.NAM = 2006
	AND GD.MALOP IN ('K11', 'K12')
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT GD.MALOP) = 2

-- Câu 12: Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN AS HV
JOIN KETQUATHI AS KQ
	ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'Co So Du Lieu'
	AND KQ.LANTHI = 1
	AND KQ.KQUA = 'Khong Dat'
	AND NOT EXISTS ( -- Chỉ lấy những học viên có lần thi <= 1
		SELECT 1
		FROM KETQUATHI AS KQ2
		WHERE KQ2.MAHV = KQ.MAHV
			AND KQ2.MAMH = KQ.MAMH
			AND KQ2.LANTHI > 1
)

-- Câu 13: Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN AS GV
WHERE NOT EXISTS ( -- Chỉ lấy những giáo viên không được phân công
	 SELECT 1
	 FROM GIANGDAY AS GD
	 WHERE GD.MAGV = GV.MAGV
)

-- Câu 14: Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN AS GV
WHERE NOT EXISTS ( -- Chỉ giữa lại giáo viên không có bất kì phân công nào
	SELECT 1
	FROM GIANGDAY AS GD
	JOIN MONHOC AS MH
		ON GD.MAMH = MH.MAMH -- Ghép bảng GIANGDAY với MONHOC
	WHERE GD.MAGV = GV.MAGV -- Kiểm tra những môn được phân công chính cho giáo viên đang xét
		AND MH.MAKHOA = GV.MAKHOA -- Kiểm tra môn học có thuộc giáo viên của khoa đó hay không
)
