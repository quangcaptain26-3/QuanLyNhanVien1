create database QuanLyNV
use QuanLyNV

create table PhongBan(
	MaPhongBan nvarchar(3) primary key,
	TenPhongBan nvarchar(30) not null unique,
	NgayThanhLap date not null,
	PhuCap decimal(10,2) not null check(PhuCap > 0)
);
go
create table NhanVien(
	MaNhanVien nvarchar(5) primary key,
	HoTen nvarchar(30) not null,
	MaPhongBan nvarchar(3) not null,
	NgayVaoLam date not null,
	MucLuong decimal(10,2) not null check (MucLuong > 0),
	foreign key (MaPhongBan) references PhongBan(MaPhongBan)
);
go
create table DuAn(
	MaDuAn nvarchar(3) primary key,
	TenDuAn nvarchar(30) not null unique,
	TongKinhPhi decimal(13,2) not null check (TongKinhPhi > 0),
	MaNhanVienPhuTrach nvarchar(5) not null,
	foreign key (MaNhanVienPhuTrach) references NhanVien(MaNhanVien)
);

-- Insert data into PhongBan table
INSERT INTO PhongBan (MaPhongBan, TenPhongBan, NgayThanhLap, PhuCap)
VALUES
('HR', 'Human Resources', '2022-01-01', 1000.00),
('IT', 'Information Technology', '2021-06-15', 1500.00),
('FN', 'Finance', '2020-03-30', 2000.00),
('MK', 'Marketing', '2019-11-25', 1200.00),
('SL', 'Sales', '2018-08-20', 1100.00);

-- Insert data into NhanVien table
INSERT INTO NhanVien (MaNhanVien, HoTen, MaPhongBan, NgayVaoLam, MucLuong)
VALUES
('NV001', 'John Smith', 'HR', '2022-05-01', 3000.00),
('NV002', 'Emma Johnson', 'IT', '2021-07-01', 3500.00),
('NV003', 'Michael Brown', 'FN', '2020-04-01', 4000.00),
('NV004', 'Olivia Davis', 'MK', '2019-12-01', 3200.00),
('NV005', 'William Taylor', 'SL', '2018-09-01', 3100.00);

-- Insert data into DuAn table
INSERT INTO DuAn (MaDuAn, TenDuAn, TongKinhPhi, MaNhanVienPhuTrach)
VALUES
('DA1', 'Project Alpha', 50000.00, 'NV001'),
('DA2', 'Project Beta', 75000.00, 'NV002'),
('DA3', 'Project Gamma', 100000.00, 'NV003'),
('DA4', 'Project Delta', 60000.00, 'NV004'),
('DA5', 'Project Epsilon', 55000.00, 'NV005');

--Cau 1
create procedure SuaDuAn
	@MaDuAn nvarchar(3),
	@TenDuAn nvarchar(30),
	@TongKinhPhi decimal(13,2),
	@MaNhanVienPhuTrach nvarchar(5)
as begin
	declare @Dem int;
	declare @Loi nvarchar(300);
	set @Loi = ' ';

	set @Dem = (select count(*) from DuAn where MaDuAn = @MaDuAn)
	if @Dem = 0
		set @Loi = N'Ma du an khong ton tai';

	set @Dem = (select count(*) from DuAn where TenDuAn = @TenDuAn and MaDuAn != @MaDuAn)
	if @Dem > 0
		set @Loi = N'Ten du an da ton tai';

	if @Loi = ' '
		update DuAn
		set TenDuAn = @TenDuAn, TongKinhPhi = @TongKinhPhi, MaNhanVienPhuTrach = @MaNhanVienPhuTrach
		where MaDuAn = @MaDuAn
	else
		raiserror(@Loi, 16, 1);
end

--Cau 2
create function TimKiemPhongBan(@TuKhoa nvarchar(40))
returns table
as return
(
	select 
		pb.MaPhongBan,
		pb.TenPhongBan,
		pb.NgayThanhLap,
		pb.PhuCap
	from PhongBan pb
	where 
		pb.MaPhongBan like '%' + @TuKhoa +'%' or
		pb.TenPhongBan like '%' + @TuKhoa + '%' or
		pb.NgayThanhLap like '%' + @TuKhoa + '%' or
		pb.PhuCap like '%' + @TuKhoa + '%'
);


--Cau 3
create procedure ThemNhanVien
	@MaNhanVien nvarchar(5),
	@HoTen nvarchar(30),
	@MaPhongBan nvarchar(3),
	@NgayVaoLam date,
	@MucLuong decimal(10,2)
as begin
	declare @Dem int;
	declare @Loi nvarchar(300);
	set @Loi = ' ';
	
	set @Dem = (select count(*) from NhanVien where MaNhanVien = @MaNhanVien)
	if @Dem > 0
		set @Loi = N'Ma nhan vien da ton tai';

	if @MucLuong < 0
		set @Loi = N'Muc luong khong duoc be hon 0';

	if @Loi = ' '
		insert into NhanVien(MaNhanVien, HoTen, MaPhongBan, NgayVaoLam, MucLuong)
		values (@MaNhanVien, @HoTen, @MaPhongBan, @NgayVaoLam, @MucLuong);
	else
		raiserror(@Loi, 16, 1);
end

create procedure SuaNhanVien
	@MaNhanVien nvarchar(5),
	@HoTen nvarchar(30),
	@MaPhongBan nvarchar(3),
	@NgayVaoLam date,
	@MucLuong decimal(10,2)
as begin
	declare @Dem int;
	declare @Loi nvarchar(300);
	set @Loi = ' ';
	
	set @Dem = (select count(*) from NhanVien where MaNhanVien = @MaNhanVien)
	if @Dem = 0
		set @Loi = N'Ma nhan vien khong ton tai';

	set @Dem = (select count(*) from NhanVien where HoTen = @HoTen and MaNhanVien != @MaNhanVien)
	if @Dem > 0
		set @Loi = N'Ten nhan vien da ton tai';

	if @MucLuong < 0
		set @Loi = N'Muc luong khong duoc be hon 0';

	if @Loi = ' '
		update NhanVien 
		set HoTen = @HoTen, MaPhongBan = @MaPhongBan, NgayVaoLam = @NgayVaoLam, MucLuong = @MucLuong
		where MaNhanVien = @MaNhanVien
	else
		raiserror(@Loi, 16, 1);
end

create procedure XoaNhanVien
	@MaNhanVien nvarchar(5)
as begin
	declare @Dem int;
	declare @Loi nvarchar(300);
	set @Loi = ' '

	set @Dem = (select count(*) from NhanVien where MaNhanVien = @MaNhanVien)
	if @Dem = 0
		set @Loi = N'Ma nhan vien khong ton tai';

	set @Dem = (select count(*) from DuAn where MaNhanVienPhuTrach = @MaNhanVien)
	if @Dem > 0
		set @Loi = N'Khong the xoa do ton tai trong bang DuAn';

	if @Loi = ' '
		delete NhanVien 
		where MaNhanVien = @MaNhanVien
	else
		raiserror(@Loi, 16, 1);
end

create function TimKiemNhanVien(@TuKhoa nvarchar(40))
returns table
as return
(
	select
		nv.MaNhanVien,
		nv.HoTen,
		pb.MaPhongBan,
		nv.NgayVaoLam,
		nv.MucLuong
	from 
		NhanVien nv
	inner join PhongBan pb on  nv.MaPhongBan = pb.MaPhongBan
	where nv.MaNhanVien like '%' + @TuKhoa + '%' or
		nv.HoTen like '%' + @TuKhoa + '%' or
		pb.MaPhongBan like '%' + @TuKhoa + '%' or
		nv.NgayVaoLam like '%' + @TuKhoa + '%' or
		nv.MucLuong like '%' + @TuKhoa + '%' 
);