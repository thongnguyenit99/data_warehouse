CREATE DATABASE ChiNhanh_2
USE ChiNhanh_2
GO
CREATE TABLE KhachHang(
 MaKhachHang nvarchar(15) not null ,
 MaHD nvarchar(15) NOT NULL ,
 HoTen nvarchar(30) not null,
 BirthDay date,
 DonGia float,
 SoLuong int,
 ThoiGian  datetime,
 TrangThai bit,
 primary key(MaKhachHang,MaHD)
)
--- THÊM DỮ LIỆU CHI NHÁNH 2
INSERT INTO KhachHang(MaKhachHang,MaHD,HoTen,BirthDay,DonGia,SoLuong,ThoiGian,TrangThai)
VALUES('KH01','HD01',N'Thông Nguyễn','1999-2-12',48590,2,'2019-4-2',1),
('KH02','HD03',N'Cảnh Nguyễn','1999-7-2',49060,2,'2019-4-5',0),
('KH03','HD02',N'Hải Nguyễn','1999-6-17',12068,1,'2019-4-4',1)

SELECT*FROM KhachHang
