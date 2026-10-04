-----------------------------------------------------
-----------CƠ SỞ DỮ LIỆU: QUẢN LÝ BÁN HÀNG-----------
-----------------------------------------------------
create database QuanLyBanHang;
go
--
use QuanLyBanHang;
go

-----------------------------------------------------
-----------I.Ngôn ngữ định nghĩa dữ liệu-------------
-----------------------------------------------------

-- Câu 1: Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ. 

-- Quan hệ: KHACHHANG
create table KHACHHANG
(
	MAKH char(4),
	HOTEN varchar(40),
	DCHI varchar(50),
	SODT varchar(20),
	NGSINH smalldatetime,
	DOANHSO money,
	NGDK smalldatetime,

	constraint PK_KHACHHANG
		primary key (MAKH)
);
go

-- Quan hệ: NHANVIEN
create table NHANVIEN
(
	MANV char(4),
	HOTEN varchar(40),
	SODT varchar(20),
	NGVL smalldatetime,

	constraint PK_NHANVIEN
		primary key (MANV)
);

go

-- Quan hệ: SANPHAM
create table SANPHAM
(
	MASP char(4),
	TENSP varchar(40),
	DVT varchar(20),
	NUOCSX varchar(40),
	GIA money,

	constraint PK_SANPHAM
		primary key (MASP)
);

go

-- Quan hệ: HOADON
create table HOADON
(
	SOHD int,
	NGHD smalldatetime,
	MAKH char(4),
	MANV char(4),
	TRIGIA money,

	constraint PK_HOADON
		primary key (SOHD),

	-- Khóa ngoại
	constraint FK_HOADON_KHACHHANG
		foreign key(MAKH)
		references KHACHHANG(MAKH),

	constraint FK_HOADON_NHANVIEN
		foreign key(MANV)
		references NHANVIEN(MANV)
);

go

-- Quan hệ: CTHD
create table CTHD
(
	SOHD int,
	MASP char(4),
	SL int,

	constraint PK_CTHD
		primary key (SOHD, MASP),

	-- Khóa ngoại
	constraint FK_CTHD_HOADON
		foreign key (SOHD)
		references HOADON(SOHD),

	constraint FK_HOADON_SANPHAM
		foreign key (MASP)
		references SANPHAM(MASP)
);

go

-- Câu 2: Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
alter table SANPHAM
add GHICHU varchar(20);

go

-- Câu 3: Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
alter table KHACHHANG
add LOAIKH tinyint;

go
-- Câu 4: Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100). 
alter table SANPHAM
alter column GHICHU varchar(100);

go

-- Câu 5: Xóa thuộc tính GHICHU trong quan hệ SANPHAM. 
alter table SANPHAM
drop column GHICHU;

go

-- Câu 6: Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, … 
alter table KHACHHANG
alter column LOAIKH varchar(20);

go

-- Câu 7: Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”) 
alter table SANPHAM
add constraint CK_SANPHAM_DVT
check (DVT in ('cay', 'hop', 'cai', 'quyen', 'chuc'));

go

-- Câu 8: Giá bán của sản phẩm từ 500 đồng trở lên. 
alter table SANPHAM
add constraint CK_SANPHAM_GIA
check (GIA >= 500);

go

-- Câu 9: Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm. 
alter table CTHD
add constraint CK_CTHD_SL
check (SL >= 1);

go

-- Câu 10: Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người  đó. 
alter table KHACHHANG
add constraint CK_KHACHHANG_NGDK
check (NGDK > NGSINH);

go

-----------------------------------------------------
-----------II.Ngôn ngữ thao tác dữ liệu--------------
-----------------------------------------------------

set dateformat YMD
go

-- Câu 1: Nhập dữ liệu cho các quan hệ trên.
-- Nhập dữ liệu cho bảng KHACHHANG
insert into KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) values
('KH01', 'Nguyen Van A', '731 Tran Hung Dao, Q5, TpHCM', '08823451', '1960-10-22', 13060000, '2006-07-22'),
('KH02', 'Tran Ngoc Han', '23/5 Nguyen Trai, Q5, TpHCM', '0908256478', '1974-04-03', 280000, '2006-07-30'),
('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan, Q1, TpHCM', '0938776266', '1980-06-12', 3860000, '2006-08-05'),
('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh, Q10, TpHCM', '0917325476', '1965-03-09', 250000, '2006-10-02'),
('KH05', 'Le Nhat Minh', '34 Truong Dinh, Q3, TpHCM', '08246108', '1950-03-10', 21000, '2006-10-28'),
('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu, Q5, TpHCM', '08631738', '1981-12-31', 915000, '2006-11-24'),
('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong, Q5, TpHCM', '0916783565', '1971-04-06', 12500, '2006-12-01'),
('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong, Q5, TpHCM', '0938435756', '1971-01-10', 365000, '2006-12-13'),
('KH09', 'Le Ha Vinh', '873 Le Hong Phong, Q5, TpHCM', '08654763', '1979-09-03', 70000, '2007-01-14'),
('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai, Q1, TpHCM', '08768904', '1983-05-02', 67500, '2007-01-16');

-- Nhập dữ liệu cho bảng NHANVIEN
insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values
('NV01', 'Nguyen Nhu Nhut', '0927345678', '2006-04-13'),
('NV02', 'Le Thi Phi Yen', '0987567390', '2006-04-21'),
('NV03', 'Nguyen Van B', '0997047382', '2006-04-27'),
('NV04', 'Ngo Thanh Tuan', '0913758498', '2006-06-24'),
('NV05', 'Nguyen Thi Truc Thanh', '0918590387', '2006-07-20');

-- Nhập dữ liệu cho bảng SANPHAM
insert into SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) values
('BC01', 'But chi', 'cay', 'Singapore', 3000),
('BC02', 'But chi', 'cay', 'Singapore', 5000),
('BC03', 'But chi', 'cay', 'Viet Nam', 3500),
('BC04', 'But chi', 'hop', 'Viet Nam', 30000),
('BB01', 'But bi', 'cay', 'Viet Nam', 5000),
('BB02', 'But bi', 'cay', 'Trung Quoc', 7000),
('BB03', 'But bi', 'hop', 'Thai Lan', 100000),
('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', 2500),
('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', 4500),
('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', 3000),
('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', 5500),
('TV05', 'Tap 100 trang chuc', 'quyen', 'Viet Nam', 23000),
('TV06', 'Tap 200 trang chuc', 'quyen', 'Viet Nam', 53000),
('TV07', 'Tap 100 trang chuc', 'quyen', 'Trung Quoc', 34000),
('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', 40000),
('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', 55000),
('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', 51000),
('ST04', 'So tay', 'quyen', 'Thai Lan', 55000),
('ST05', 'So tay mong', 'quyen', 'Thai Lan', 20000),
('ST06', 'Phan viet bang', 'hop', 'Viet Nam', 5000),
('ST07', 'Phan khong bui', 'hop', 'Viet Nam', 7000),
('ST08', 'Bong bang', 'cai', 'Viet Nam', 1000),
('ST09', 'But long', 'cay', 'Viet Nam', 5000),
('ST10', 'But long', 'cay', 'Trung Quoc', 7000);

-- Nhập dữ liệu ch bảng HOADON
insert into HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) values
(1001, '2006-07-23', 'KH01', 'NV01', 320000),
(1002, '2006-08-12', 'KH01', 'NV02', 840000),
(1003, '2006-08-23', 'KH02', 'NV01', 100000),
(1004, '2006-09-01', 'KH02', 'NV01', 180000),
(1005, '2006-10-20', 'KH01', 'NV02', 3800000),
(1006, '2006-10-16', 'KH01', 'NV03', 2430000),
(1007, '2006-10-28', 'KH03', 'NV03', 510000),
(1008, '2006-10-28', 'KH01', 'NV03', 440000),
(1009, '2006-10-28', 'KH03', 'NV04', 200000),
(1010, '2006-11-01', 'KH01', 'NV01', 5200000),
(1011, '2006-11-04', 'KH04', 'NV03', 250000),
(1012, '2006-11-30', 'KH05', 'NV03', 21000),
(1013, '2006-12-12', 'KH06', 'NV01', 5000),
(1014, '2006-12-31', 'KH03', 'NV02', 3150000),
(1015, '2007-01-01', 'KH06', 'NV01', 910000),
(1016, '2007-01-01', 'KH07', 'NV02', 12500),
(1017, '2007-01-02', 'KH08', 'NV03', 35000),
(1018, '2007-01-13', 'KH08', 'NV03', 330000),
(1019, '2007-01-13', 'KH01', 'NV03', 30000),
(1020, '2007-01-14', 'KH09', 'NV04', 70000),
(1021, '2007-01-16', 'KH10', 'NV03', 67500),
(1022, '2007-01-16', NULL,   'NV03', 7000),
(1023, '2007-01-17', NULL,   'NV01', 330000);

-- Nhập dữ liệu cho bảng CTHD
insert into CTHD(SOHD, MASP, SL) values
(1001,'TV02',10),
(1001,'ST01',5),
(1001,'BC01',5),
(1001,'BC02',10),
(1001,'ST08',10),
(1002,'BC04',20),
(1002,'BB01',20),
(1002,'BB02',20),
(1003,'BB03',10),
(1004,'TV01',20),
(1004,'TV02',10),
(1004,'TV03',10),
(1004,'TV04',10),
(1005,'TV05',50),
(1005,'TV06',50),
(1006,'TV07',20),
(1006,'ST01',30),
(1006,'ST02',10),
(1007,'ST03',10),
(1008,'ST04',8),
(1009,'ST05',10),
(1010,'TV07',50),
(1010,'ST07',50),
(1010,'ST08',100),
(1010,'ST04',50),
(1010,'TV03',100),
(1011,'ST06',50),
(1012,'ST07',3),
(1013,'ST08',5),
(1014,'BC02',80),
(1014,'BB02',100),
(1014,'BC04',60),
(1014,'BB01',50),
(1015,'BB02',30),
(1015,'BB03',7),
(1016,'TV01',5),
(1017,'TV02',1),
(1017,'TV03',1),
(1017,'TV04',5),
(1018,'ST04',6),
(1019,'ST05',1),
(1019,'ST06',2),
(1020,'ST07',10),
(1021,'ST08',5),
(1021,'TV01',7),
(1021,'TV02',10),
(1022,'ST07',1),
(1023,'ST04',6);

-- Câu 2: Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG. 
select * into SANPHAM1 from SANPHAM
select * from SANPHAM1

select * into KHACHHANG1 from KHACHHANG
select * from KHACHHANG1

go

-- Câu 3: Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
update SANPHAM1 set GIA = GIA * 1.05 where NUOCSX = 'Thai Lan'
go

-- Câu 4: Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
update SANPHAM1 set GIA = GIA *0.95 where NUOCSX = 'Trung Quoc' and GIA <= 10000
select * from SANPHAM1
go

-- Câu 5: Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1). 
update KHACHHANG1 set LOAIKH = 'Vip' where (NGDK < '2007-01-01' and DOANHSO >= 10000000) or (NGDK >= '2007-01-01' and DOANHSO >= 2000000)
select * from KHACHHANG1

go
