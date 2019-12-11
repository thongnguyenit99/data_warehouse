CREATE DATABASE ChiNhanh_1
USE ChiNhanh_1
GO

CREATE TABLE ChiNhanh_1(
 MaKhachHang nvarchar(20) not null primary key,
 HoKhachHang nvarchar(20) not null,
 TenKhachHang nvarchar(20) not null,
 NgaySinh  char(2),
 ThangSinh char(2) ,
 NamSinh char(4),
 ThoiGian  datetime,
 TrangThai char(1)
)
GO
---THÊM THÔNG TIN---
INSERT INTO ChiNhanh_1(MaKhachHang,HoKhachHang,TenKhachHang,NgaySinh,ThangSinh,NamSinh,ThoiGian,TrangThai)
VALUES('KH1',N'Nguyễn',N'Văn Thông','08','09','1999','2019-12-9','1'),
('KH2',N'Nguyễn',N'Quốc Cảnh','12','01','1999','2019-12-8','0'),
('KH3',N'Nguyễn',N'Ngọc Đức Hải','03','10','1999','2019-12-7','1')
GO
SELECT*FROM ChiNhanh_1
