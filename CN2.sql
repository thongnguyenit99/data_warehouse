CREATE DATABASE ChiNhanh_2
USE ChiNhanh_2
GO
CREATE TABLE ChiNhanh_2(
 MaKhachHang nvarchar(15) not null primary key,
 MaHD nvarchar(15) NOT NULL ,
 HoTen nvarchar(30) not null,
 BirthDay date,
 DonGia float,
 SoLuong int,
 ThoiGian  datetime,
 TrangThai char(1)
)
--- THÊM DỮ LIỆU CHI NHÁNH 2
INSERT INTO ChiNhanh_2(MaKhachHang,MaHD,HoTen,BirthDay,DonGia,SoLuong,ThoiGian,TrangThai)
VALUES('KH01','001',N'Thông Nguyễn','1999-2-12',48590,2,'2019-4-2','1'),
('KH02','003',N'Cảnh Nguyễn','1999-7-2',49060,2,'2019-4-5','0'),
('KH03','002',N'Hải Nguyễn','1999-6-17',12068,1,'2019-4-4','1')

SELECT*FROM ChiNhanh_2
