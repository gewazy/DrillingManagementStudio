USE [u_dojurkow]
GO
/****** Object:  UserDefinedFunction [dbo].[f_current_month]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[f_current_month] (@month smallint, @year smallint)
returns @result table (current_day varchar(2))
as
begin
	declare @date date = datefromparts(@year, @month, 1)
	
	while MONTH(@date) = @month
		begin
			insert into @result(current_day)
			values (CAST(DAY(@date) AS VARCHAR(2)));
			set @date = dateadd(day, 1, @date)
		end;
	return;
end;
GO
/****** Object:  UserDefinedFunction [dbo].[f_descriptor]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[f_descriptor] (@team_id int)
returns char(2)
AS
BEGIN
    declare @desc char(2)
    declare @ur varchar(5)
    
    if exists (select * from inuse where team_id = @team_id and date_to is null )
        begin
        set @ur = (select rt.eq_type 
                    from inuse i 
                    join Rigs r on i.rig_id = r.id
                    join RigTypes rt on r.type_id = rt.id
                    where team_id = @team_id and  date_to is null);
        if @ur like '%PAT%' set @desc = 'xt' 
        else set @desc = 'xr';
        end
    else set @desc = NULL 
    return @desc;
END;
GO
/****** Object:  Table [dbo].[Failures]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Failures](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[rig_id] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[fail_descrip] [varchar](256) NOT NULL,
	[end_date] [date] NULL,
	[repair_descrip] [varchar](256) NULL,
	[cost] [money] NULL,
 CONSTRAINT [PK_Failures] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InUse]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InUse](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[team_id] [int] NOT NULL,
	[rig_id] [int] NOT NULL,
	[date_from] [date] NOT NULL,
	[date_to] [date] NULL,
 CONSTRAINT [PK_InUse] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PositionDetails]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[driller_id] [int] NOT NULL,
	[post_id] [tinyint] NOT NULL,
	[date_from] [date] NOT NULL,
	[date_to] [date] NULL,
 CONSTRAINT [PK_PositionDetails] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[id] [int] NOT NULL,
	[phone] [char](11) NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Drillers]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drillers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](10) NOT NULL,
	[last_name] [nvarchar](20) NOT NULL,
	[team_id] [int] NULL,
 CONSTRAINT [PK_Drillers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teams](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[leader_id] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NULL,
 CONSTRAINT [PK_Teans] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Positions]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Positions](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[position] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Positions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Positions] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Position] UNIQUE NONCLUSTERED 
(
	[position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Drillers]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE           view [dbo].[VW_Drillers]
as
select 
	d.id,
	first_name + ' ' + last_name as Driller,
	c.phone as Numer_telefonu,
	team_id as Numer_Brygady,
	t.leader_id as id_brygadzisty,
	(select first_name + ' ' + last_name from Drillers where id = t.leader_id) as Brygadzista,
	po.id as id_stanowiska,
	position as Stanowisko,
	date_from as Początek_pracy_na_stanowisku
from Drillers d 
left join Contacts c on d.id = c.id
left join PositionDetails pd on d.id = pd.driller_id
left join Positions po on pd.post_id = po.id
left join Teams t on t.id = d.team_id and t.end_date is null
where pd.date_to is null;
GO
/****** Object:  Table [dbo].[RigTypes]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RigTypes](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[eq_type] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Table1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Types] UNIQUE NONCLUSTERED 
(
	[eq_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_eq_type] UNIQUE NONCLUSTERED 
(
	[eq_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rigs]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rigs](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[type_id] [tinyint] NOT NULL,
	[inventory_no] [varchar](20) NOT NULL,
	[date_in] [date] NOT NULL,
	[date_out] [date] NULL,
 CONSTRAINT [PK_Devices] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Team_leaders]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[VW_Team_leaders]
as
with stan as 
    (select 
        r.id, 
        CASE
            when f.id is null then 'OK'
            else 'Fail'
        END as Stan_techniczny
    from Rigs r left join Failures f on r.id = F.rig_id and f.end_date is null
    ) 
select 
    t.id as Team_id, 
    t.leader_id as Brygadzista, 
    d.Driller,
    rig_id as Rig_id,
    isnull(r.inventory_no, 'Brak') as Rig_no,
    isnull(rt.eq_type, 'N/A') as Rig_Type,
    isnull(stan.Stan_techniczny, 'N/A') as Stan_techniczny
from teams t 
    left join inuse iu on iu.team_id = t.id AND iu.date_to IS NULL
    left join Rigs r on r.id = iu.rig_id and r.date_out is null 
    left join RigTypes rt on r.type_id = rt.id 
    join VW_Drillers d on d.id = t.leader_id
    left join stan on stan.id = r.id
where t.end_date is null ;
GO
/****** Object:  Table [dbo].[Planning]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Planning](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[station] [int] NOT NULL,
	[team_id] [int] NOT NULL,
	[add_date] [date] NOT NULL,
	[expire_date] [date] NOT NULL,
	[done] [date] NULL,
	[canceled] [bit] NOT NULL,
 CONSTRAINT [PK_Plan] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Planned_points]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_Planned_points]
as
select p.station, tl.team_id, tl.Brygadzista, tl.Urzadzenie, expire_date 
from Planning p join VW_Team_leaders tl on p.team_id = tl.team_id
where canceled = 0 and done is null;
GO
/****** Object:  View [dbo].[VW_Teams_summary_plan]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_Teams_summary_plan]
AS
select 
	team_id
	, Brygadzista
	, Urzadzenie
	, isnull((select count(*) 
			  from Planning 
			  where 
				team_id = tl.team_id 
				and canceled = 0 
				and done is null 
			  group by team_id), 0) as Zaplanowano 
from VW_team_leaders tl 
GO
/****** Object:  Table [dbo].[Attendance]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[driller_id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[is_present] [bit] NOT NULL,
 CONSTRAINT [PK_Attendance] PRIMARY KEY CLUSTERED 
(
	[driller_id] ASC,
	[date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_attendance_report2]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     VIEW [dbo].[VW_attendance_report2]
AS
SELECT *
FROM (
    SELECT driller_id, first_name + ' ' + last_name as Driller, CAST(DAY(date) AS VARCHAR(2)) AS day, 'Y' AS is_present
    FROM Attendance join Drillers on Drillers.id = Attendance.driller_id
    WHERE date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND date < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
        AND is_present = 1
    UNION ALL
    SELECT driller_id, first_name + ' ' + last_name as Driller, CAST(DAY(date) AS VARCHAR(2)) AS day, 'N' AS is_present
    FROM Attendance join Drillers on Drillers.id = Attendance.driller_id
    WHERE date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND date < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
        AND is_present = 0
	) AS attendance_data
	PIVOT (
		MIN(is_present)
		FOR day IN ([1], [2], [3], [4], [5], [6], [7], [8] , [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31])
	) AS attendance_report;
GO
/****** Object:  View [dbo].[VW_attendance_report3]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE        VIEW [dbo].[VW_attendance_report3]
AS
SELECT *
FROM (
-- tabela obecności
    SELECT driller_id, 
		   first_name + ' ' + last_name as Driller, 
		   CAST(DAY(date) AS VARCHAR(2)) AS day, 
		   'Y' AS is_present
    FROM Attendance 
	JOIN Drillers on Drillers.id = Attendance.driller_id
    -- wybór wpisów dla bierzącego miesiąca
	WHERE 
		year(date) = year(getdate()) 
		AND month(date) = month(getdate())  
		AND is_present = 1

	UNION ALL

-- tabela nieobecności
    SELECT driller_id, 
	   	   first_name + ' ' + last_name as Driller, 
		   CAST(DAY(date) AS VARCHAR(2)) AS day, 
		   'N' AS is_present
    FROM Attendance 
	JOIN Drillers on Drillers.id = Attendance.driller_id
    -- wybór wpisów dla bierzącego miesiąca
	WHERE 
		year(date) = year(getdate()) 
		AND month(date) = month(getdate())
        AND is_present = 0
	) AS attendance_data
-- przestawienie tabeli 
	PIVOT (
		MIN(is_present)
					-- nagłówki do tabeli wynikowej.  
		FOR day IN ([1], [2], [3], [4], [5], [6], [7], [8] , [9], [10], [11], [12], [13], 
					[14], [15],	[16], [17], [18], [19],	[20], [21], [22], [23], [24], [25], 
					[26], [27], [28], [29], [30], [31])
	) AS attendance_report;
GO
/****** Object:  View [dbo].[VW_free_rigs]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   VIEW [dbo].[VW_free_rigs]
as 
-- tabela wyświetla informacje na temat sprawnych urządzeń bez przydziału brygady.
select 
    r.id, 
    t.eq_type, 
    r.inventory_no 
from Rigs r join RigTypes t on r.type_id = t.id
where 
    r.id not in (select rig_id from InUse where date_to is null) 
    and r.id not in (select rig_id from Failures where end_date is null)
    and r.date_out is null;
GO
/****** Object:  View [dbo].[VW_attendance_report]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE       VIEW [dbo].[VW_attendance_report]
AS
SELECT *
FROM (
-- tabela obecności
    SELECT driller_id, first_name + ' ' + last_name as Driller, CAST(DAY(date) AS VARCHAR(2)) AS day, 'Y' AS is_present
    FROM Attendance join Drillers on Drillers.id = Attendance.driller_id
    -- wybór wpisów dla bierzącego miesiąca
	WHERE date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND date < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
        AND is_present = 1
    UNION ALL
-- tabela nieobecności
    SELECT driller_id, first_name + ' ' + last_name as Driller, CAST(DAY(date) AS VARCHAR(2)) AS day, 'N' AS is_present
    FROM Attendance join Drillers on Drillers.id = Attendance.driller_id
    -- wybór wpisów dla bierzącego miesiąca
	WHERE date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND date < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)
        AND is_present = 0
	) AS attendance_data
-- przestawienie tabeli 
	PIVOT (
		MIN(is_present)
					-- nagłówki do tabeli wynikowej. 
		FOR day IN ([1], [2], [3], [4], [5], [6], [7], [8] , [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31])
	) AS attendance_report;
GO
/****** Object:  Table [dbo].[Boreholes]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Boreholes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Station] [int] NULL,
	[Station_2] [int] NOT NULL,
	[depth_1] [decimal](4, 1) NOT NULL,
	[depth_2] [decimal](4, 1) NULL,
	[depth_3] [decimal](4, 1) NULL,
	[pipe_1] [decimal](4, 1) NOT NULL,
	[pipe_2] [decimal](4, 1) NULL,
	[pipe_3] [decimal](4, 1) NULL,
	[bags] [tinyint] NULL,
	[lithology] [nvarchar](124) NULL,
	[team_id] [int] NOT NULL,
	[RigType] [varchar](10) NOT NULL,
	[drilling_date] [date] NOT NULL,
	[remarks] [nvarchar](124) NULL,
	[WGS_Latitude] [decimal](8, 6) NOT NULL,
	[WGS_Longitude] [decimal](9, 6) NOT NULL,
	[redrill] [bit] NOT NULL,
	[VP_to_SP] [bit] NOT NULL,
 CONSTRAINT [PK_Boreholes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DrillerHist]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DrillerHist](
	[logid] [int] IDENTITY(1,1) NOT NULL,
	[driller_id] [int] NOT NULL,
	[team_id] [int] NULL,
	[mod_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fuel]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fuel](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[rig_id] [int] NOT NULL,
	[amount] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_Fuel] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[old_plan]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[old_plan](
	[station] [int] NOT NULL,
	[team_id] [int] NOT NULL,
	[add_date] [date] NOT NULL,
	[expire_date] [date] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Removal]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Removal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[BH_id] [int] NOT NULL,
	[team_id] [int] NOT NULL,
	[date] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Removal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Theory]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Theory](
	[Station] [int] NOT NULL,
	[Descriptor] [char](3) NOT NULL,
	[WGS_Latitude] [decimal](8, 6) NOT NULL,
	[WGS_Longitude] [decimal](9, 6) NOT NULL,
	[survey_date] [date] NOT NULL,
	[drilling_date] [date] NULL,
 CONSTRAINT [PK_Theory] PRIMARY KEY CLUSTERED 
(
	[Station] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attendance] ADD  CONSTRAINT [DF_Attendance_date]  DEFAULT (CONVERT([date],getdate())) FOR [date]
GO
ALTER TABLE [dbo].[Boreholes] ADD  CONSTRAINT [DF_Boreholes_drilling_date]  DEFAULT (CONVERT([date],getdate())) FOR [drilling_date]
GO
ALTER TABLE [dbo].[Boreholes] ADD  CONSTRAINT [DF_Boreholes_redrill]  DEFAULT ((0)) FOR [redrill]
GO
ALTER TABLE [dbo].[Boreholes] ADD  CONSTRAINT [DF_Boreholes_VP_to_SP]  DEFAULT ((0)) FOR [VP_to_SP]
GO
ALTER TABLE [dbo].[DrillerHist] ADD  CONSTRAINT [df_driller_team_hist_mod_date]  DEFAULT (getdate()) FOR [mod_date]
GO
ALTER TABLE [dbo].[Failures] ADD  CONSTRAINT [DF_Failures_start_date]  DEFAULT (CONVERT([date],getdate())) FOR [start_date]
GO
ALTER TABLE [dbo].[Fuel] ADD  CONSTRAINT [DF_Fuel_date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[InUse] ADD  CONSTRAINT [DF_InUse_date_from]  DEFAULT (CONVERT([date],getdate())) FOR [date_from]
GO
ALTER TABLE [dbo].[Planning] ADD  CONSTRAINT [DF_Plan_add_date]  DEFAULT (CONVERT([date],getdate())) FOR [add_date]
GO
ALTER TABLE [dbo].[Planning] ADD  CONSTRAINT [DF_Plan_expire_date]  DEFAULT (CONVERT([date],dateadd(day,(14),getdate()))) FOR [expire_date]
GO
ALTER TABLE [dbo].[Planning] ADD  CONSTRAINT [DF_Plan_canceled]  DEFAULT ((0)) FOR [canceled]
GO
ALTER TABLE [dbo].[PositionDetails] ADD  CONSTRAINT [DF_PositionDetails_date_from]  DEFAULT (CONVERT([date],getdate())) FOR [date_from]
GO
ALTER TABLE [dbo].[Removal] ADD  CONSTRAINT [DF_Removal_date]  DEFAULT (CONVERT([date],getdate())) FOR [date]
GO
ALTER TABLE [dbo].[Rigs] ADD  CONSTRAINT [DF_Rigs_date_in]  DEFAULT (CONVERT([date],getdate())) FOR [date_in]
GO
ALTER TABLE [dbo].[Teams] ADD  CONSTRAINT [DF_Teams_start_date]  DEFAULT (CONVERT([date],getdate())) FOR [start_date]
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD  CONSTRAINT [FK_Attendance_Drillers] FOREIGN KEY([driller_id])
REFERENCES [dbo].[Drillers] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attendance] CHECK CONSTRAINT [FK_Attendance_Drillers]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [FK_Boreholes_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [FK_Boreholes_Teams]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [FK_Boreholes_Theory] FOREIGN KEY([Station])
REFERENCES [dbo].[Theory] ([Station])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [FK_Boreholes_Theory]
GO
ALTER TABLE [dbo].[Contacts]  WITH CHECK ADD  CONSTRAINT [FK_Contacts_Drillers] FOREIGN KEY([id])
REFERENCES [dbo].[Drillers] ([id])
GO
ALTER TABLE [dbo].[Contacts] CHECK CONSTRAINT [FK_Contacts_Drillers]
GO
ALTER TABLE [dbo].[Drillers]  WITH CHECK ADD  CONSTRAINT [FK_Drillers_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Drillers] CHECK CONSTRAINT [FK_Drillers_Teams]
GO
ALTER TABLE [dbo].[Failures]  WITH CHECK ADD  CONSTRAINT [FK_Failures_Rigs] FOREIGN KEY([rig_id])
REFERENCES [dbo].[Rigs] ([id])
GO
ALTER TABLE [dbo].[Failures] CHECK CONSTRAINT [FK_Failures_Rigs]
GO
ALTER TABLE [dbo].[Fuel]  WITH CHECK ADD  CONSTRAINT [FK_Fuel_Rigs] FOREIGN KEY([rig_id])
REFERENCES [dbo].[Rigs] ([id])
GO
ALTER TABLE [dbo].[Fuel] CHECK CONSTRAINT [FK_Fuel_Rigs]
GO
ALTER TABLE [dbo].[InUse]  WITH CHECK ADD  CONSTRAINT [FK_InUse_Rigs] FOREIGN KEY([rig_id])
REFERENCES [dbo].[Rigs] ([id])
GO
ALTER TABLE [dbo].[InUse] CHECK CONSTRAINT [FK_InUse_Rigs]
GO
ALTER TABLE [dbo].[InUse]  WITH CHECK ADD  CONSTRAINT [FK_InUse_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
GO
ALTER TABLE [dbo].[InUse] CHECK CONSTRAINT [FK_InUse_Teams]
GO
ALTER TABLE [dbo].[Planning]  WITH CHECK ADD  CONSTRAINT [FK_Plan_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
GO
ALTER TABLE [dbo].[Planning] CHECK CONSTRAINT [FK_Plan_Teams]
GO
ALTER TABLE [dbo].[Planning]  WITH CHECK ADD  CONSTRAINT [FK_Plan_Theory] FOREIGN KEY([station])
REFERENCES [dbo].[Theory] ([Station])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Planning] CHECK CONSTRAINT [FK_Plan_Theory]
GO
ALTER TABLE [dbo].[PositionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PositionDetails_Drillers] FOREIGN KEY([driller_id])
REFERENCES [dbo].[Drillers] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PositionDetails] CHECK CONSTRAINT [FK_PositionDetails_Drillers]
GO
ALTER TABLE [dbo].[PositionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PositionDetails_Positions] FOREIGN KEY([post_id])
REFERENCES [dbo].[Positions] ([id])
GO
ALTER TABLE [dbo].[PositionDetails] CHECK CONSTRAINT [FK_PositionDetails_Positions]
GO
ALTER TABLE [dbo].[Removal]  WITH NOCHECK ADD  CONSTRAINT [FK_Removal_Boreholes] FOREIGN KEY([BH_id])
REFERENCES [dbo].[Boreholes] ([id])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Removal] CHECK CONSTRAINT [FK_Removal_Boreholes]
GO
ALTER TABLE [dbo].[Removal]  WITH CHECK ADD  CONSTRAINT [FK_Removal_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
GO
ALTER TABLE [dbo].[Removal] CHECK CONSTRAINT [FK_Removal_Teams]
GO
ALTER TABLE [dbo].[Rigs]  WITH CHECK ADD  CONSTRAINT [FK_Rigs_Types] FOREIGN KEY([type_id])
REFERENCES [dbo].[RigTypes] ([id])
GO
ALTER TABLE [dbo].[Rigs] CHECK CONSTRAINT [FK_Rigs_Types]
GO
ALTER TABLE [dbo].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Teams_Drillers_leader] FOREIGN KEY([leader_id])
REFERENCES [dbo].[Drillers] ([id])
GO
ALTER TABLE [dbo].[Teams] CHECK CONSTRAINT [FK_Teams_Drillers_leader]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_depth_1] CHECK  (([depth_1]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_depth_1]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_depth_2] CHECK  (([depth_2]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_depth_2]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_depth_3] CHECK  (([depth_3]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_depth_3]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_pipe_1] CHECK  (([pipe_1]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_pipe_1]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_pipe_2] CHECK  (([pipe_2]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_pipe_2]
GO
ALTER TABLE [dbo].[Boreholes]  WITH CHECK ADD  CONSTRAINT [CK_Boreholes_pipe_3] CHECK  (([pipe_3]>(0)))
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [CK_Boreholes_pipe_3]
GO
ALTER TABLE [dbo].[Contacts]  WITH CHECK ADD  CONSTRAINT [CK_Contacts_phone] CHECK  (([phone] like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Contacts] CHECK CONSTRAINT [CK_Contacts_phone]
GO
ALTER TABLE [dbo].[Fuel]  WITH CHECK ADD  CONSTRAINT [CK_Fuel] CHECK  (([amount]>(0)))
GO
ALTER TABLE [dbo].[Fuel] CHECK CONSTRAINT [CK_Fuel]
GO
/****** Object:  StoredProcedure [dbo].[p_add_driller]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE            procedure [dbo].[p_add_driller]
@firstname varchar(10),
@lastname varchar(20),
@position_id char(20),
@phone char(12) = null
as
begin
	declare @msg2 varchar(50) = 'Nie ma stanowiska o id: ' + @position_id;

	if not exists (select * from Positions where id = @position_id)
		throw 50002, @msg2, 1;
	begin try
		begin tran
			
		declare @driller_id int;

		insert into Drillers(first_name, last_name)
		values (@firstname, @lastname);
		
		set @driller_id = SCOPE_IDENTITY();

		insert into positiondetails(driller_id, post_id)
		values (@driller_id, @position_id);
		
		insert into Contacts (id, phone)
		values (@driller_id, @phone);

		commit;
	end try
	begin catch
		if @@trancount >= 1
			rollback;
		throw;
	end catch;
end;
GO
/****** Object:  StoredProcedure [dbo].[p_add_driller_to_team]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[p_add_driller_to_team]
@driller_id int,
@team_id int
AS
begin
	declare @msg1 varchar(100) = 'Wiertacz o numerze ' + cast(@driller_id as varchar) + ' nie istnieje!';
	declare @msg2 varchar(100) = 'Nie ma brygady o id: ' + cast(@team_id as varchar) + '!';
	declare @msg3 varchar(100) = 'Wiertacz o numerze ' + cast(@driller_id as varchar) + ' jest brygadzistą w innym zespole! Zamknij wcześniej zespół.';

	if not exists (select * from Drillers where id = @driller_id)
		throw 50001, @msg1, 1;
	if not exists (select * from teams where id = @team_id)
		throw 50002, @msg2, 1;
	if exists (select * from teams where leader_id = @driller_id and end_date is null)
		throw 50003, @msg3, 1;
	
	--dodanie numeru brygady do tabeli drillers
	update Drillers
	set team_id = @team_id
	where id = @driller_id;

end;
GO
/****** Object:  StoredProcedure [dbo].[p_add_production]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[p_add_production]
    @team_id int,
    @station int,
    @drilling_date DATE = NULL,
    @depth_1 DECIMAL(4,1),
    @depth_2 DECIMAL(4,1) = NULL,
    @depth_3 DECIMAL(4,1) = NULL,
    @pipe_1 DECIMAL(4,1),
    @pipe_2 DECIMAL(4,1) = NULL,
    @pipe_3 DECIMAL(4,1) = NULL,
    @bags tinyint = 0,
    @lithology nvarchar(124) = null,
    @remarks nvarchar(124) = null,
    @lat decimal(8,6) = 0,
    @long decimal(9, 6) = 0,
    @redrill bit = 0,
    @vp_sp bit = 0

AS
BEGIN
    --raporty błędów
    declare @msg1 varchar(64) = CONCAT('Nie ma brygady o numerze: ', @team_id, '.')
    declare @msg2 varchar(64) = CONCAT('Numer ', @station, ' jest błędny.')
    declare @msg3 varchar(64) = CONCAT('Punkt ', @station, ' był już wiercony. Czy jest to redrill?')
    declare @msg4 varchar(64) = CONCAT('Punkt ', @station, ' jest wibratorowy. Czy jest zmiana?')

    --sprawdzenie czy istnieje brygada o danym id
    if not exists (select * from Teams where id = @team_id and end_date is null)
		    throw 50001, @msg1, 1;
    
    --sprawdzenie czy istnieje punkt station w theory 
    if not exists (select * from Theory where station = @station)
		    throw 50002, @msg2, 1;
    
    --sprawdzenie czy punkt byl juz wiercony - jesli tak musi miec zaznaczone redrill
    if exists (select * from theory where station = @station and drilling_date is not null) and @redrill = 0
        throw 50003, @msg3, 1;
    
    --sprawdzenie czy punkt byl przeznaczony do wiercenia, jesli nie musi miec zaznaczone vp_sp
    if exists (select * from theory where station = @station and descriptor not in ('xt', 'xr')) and @vp_sp = 0
        throw 50004, @msg4, 1;
    

    --OBSŁUGA ZMIENNYCH
    --ustawienie daty dzisiejszej, jeśli data nie podana
    IF @drilling_date is NULL
      set @drilling_date = GETDATE();
    
    -- jesli podano współrzędne, dodac prefiks 'NP' (nowa pozycja) do pola reamrks w tabeli boreholes
    -- jesli nie podano współrzędnych, kopiowanie współrzędne z theory -> boreholes  
    IF @lat != 0 and @long != 0
        set @remarks = concat('NP ', @remarks)
    ELSE
        BEGIN
            set @lat = (select WGS_Latitude from Theory where station = @station);
            set @long = (select WGS_Longitude from Theory where Station = @station);
        END;

    -- ustalić urządzenie dla brygady
    declare @RigType VARCHAR(5)
    set @RigType = (select Rig_Type from VW_Team_leaders where Team_id = @team_id)
    
    -- wprowadzenie danych
    BEGIN TRY
        BEGIN TRANSACTION
            --wprowadzenie daty w tabeli planning w done, jeśli punkt był zaplanowany
            IF exists (select * from Planning where station = @station and done is null and canceled = 0)
                UPDATE Planning
                SET done = @drilling_date
                where station = @station and canceled = 0 and done is null;
    
            --wprowadzenie drillingdate do tabeli theory
            UPDATE Theory
            set drilling_date = @drilling_date
            where station = @station and drilling_date is null;

            --dodanie rekordu do tabeli boreholes
            INSERT INTO Boreholes VALUES 
                (@station, @station, @depth_1, @depth_2, @depth_3, @pipe_1, @pipe_2, @pipe_3, @bags,
                @lithology, @team_id, @RigType, @drilling_date, @remarks, @lat, @long, @redrill, @vp_sp); 
        COMMIT;
    END TRY
    BEGIN CATCH
      if @@TRANCOUNT >= 1
        rollback;
        throw;
    end catch;
END;
GO
/****** Object:  StoredProcedure [dbo].[p_add_rig_to_team]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      procedure [dbo].[p_add_rig_to_team]
-- procedura dodaje lub odejmuje urzadzenie od brygady

@team_id int,
@rig_id int = -1  -- jesli nie  jest podane prawidlowe id, zabranie uzadzenia
as 
begin
    -- sprawdzenie czy istnieją podana brygada i urzadzenie
    
    declare @msg1 varchar(40)= 'Brygada o podanym id nie istnieje!'
    declare @msg2 varchar(40)= 'Urządzenie o podanym id nie istnieje!'
    
    if not exists (select * from teams where id = @team_id and end_date is null)
        throw 50001, @msg1, 1;
        
    IF @rig_id = -1
        BEGIN
            if exists (select * 
                       from inuse 
                       where team_id = @team_id and date_to is null)
                update InUse
                set date_to = GETDATE()
                where team_id = @team_id and date_to is null;
        END;
    ELSE
        BEGIN
            -- cd sprawdzenie czy istnieje urządzenie
            if not exists (select * 
                           from Rigs 
                           where id = @rig_id and date_out is null)
                throw 50001, @msg2, 1;
                
            begin try
                begin tran
                    -- sprawdzic czy dany zespól ma juz jakies urzadzenie, 
                    -- jeśli tak anulować wpis
                    
                    if exists (select * 
                               from inuse 
                               where team_id = @team_id and date_to is null)
                        update InUse
                        set date_to = GETDATE()
                        where team_id = @team_id and date_to is null;
                        
                    insert into inuse (team_id, rig_id)
                    VALUES (@team_id, @rig_id)
                commit;
            end try
            begin catch
                if @@TRANCOUNT >= 1
                    rollback;
                    throw;
            end catch;
        END;
END;

GO
/****** Object:  StoredProcedure [dbo].[p_close_team]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- procedura służy do zamykania zespołów
CREATE   PROCEDURE [dbo].[p_close_team]
@team INT
AS
BEGIN
    DECLARE @msg varchar(50) = 'Brygada o numerze ' + 
                                cast(@team as varchar(3)) + ' nie istnieje.'
    IF NOT EXISTS (select * from teams where id = @team and end_date is null)
        THROW 50001, @msg, 1;
    
    begin try
        begin tran
            -- zamkniecie zespołu
            
            update teams set end_date = getdate() where id = @team;
            
            -- uwolnienie urządzenia wiertniczego, wykorzystanie procedury
            -- p_add_rig_to_team
            
            exec p_add_rig_to_team @team;
            
            -- anulowanie wszystkich zaplanowanych a niezrealizowanch
            -- zadań dla danego zespołu
            
            update Planning set canceled = 1 where team_id = @team and done is null;
            
            -- 'uwolnienie' pracowników z brygady,
            -- na tabeli drillers trigger 'tr_drller_team_hist' zapisuje historię
            -- prznależności pracowników do brygad.
            
            update drillers set team_id = null where team_id = @team;
        
        commit;
    end try
    begin catch
        if @@trancount >= 1
        rollback;
        throw;
    end catch;
end;
GO
/****** Object:  StoredProcedure [dbo].[p_create_team]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      procedure [dbo].[p_create_team]
@team_leader int
as
begin
	declare @msg varchar(80) = 'Wiertacz o numerze' + cast(@team_leader as varchar) + ' nie istnieje.';
	declare @msg2 varchar(100) = 'Wiertacz o numerze ' + cast(@team_leader as varchar) + ' jest brygadzistą w innym zespole! Zamknij wcześniej zespół.';

	-- sprawdzenie czy istnieje wiertacz o takim id
	if not exists (select * from Drillers where id = @team_leader)
		throw 50001, @msg, 1;
	-- -- sprawdzenie czy wiertacz o id jest juz brygadzista
	if exists (select * from teams where leader_id = @team_leader and end_date is null)
		throw 50002, @msg2, 1;


	begin try
		begin tran
			
		--jeżeli wiertacz jest juz w innej brygadzie, wyciagamy go z brygady (o ile nie jest brydadzista)
	--	if exists (select * from Drillers where id = @team_leader and team_id is not null)
	--		update Drillers
	--		set team_id = NULL
	--		where id = @team_leader;
		
		-- tworzenie nowego zespołu
		INSERT INTO Teams (leader_id) values (@team_leader);

		declare @team_id int 
		set @team_id = SCOPE_IDENTITY()

		--wstawienie numeru zespołu do tabeli drillers
		update Drillers 
		set team_id = @team_id
		where id = @team_leader;

		commit;
	end try
	begin catch
		if @@trancount >= 1
			rollback;
		throw;
	end catch;
end;
GO
/****** Object:  StoredProcedure [dbo].[p_drilling_plan]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[p_drilling_plan]
@team_id int,
@start int, --poczatek przedziału do przeszukiwanie tabeli theory
@end int --koniec przedziału do przeszukiwania tabeli
AS
BEGIN
    
    -- sprawdza czy istnieje zespół o podanym ID
	declare @msg1 varchar(50) = 'Nie ma brygady o numerze: ' + cast(@team_id as varchar) + '.';
	if not exists (select * from Teams where id = @team_id and end_date is null)
		throw 50001, @msg1, 1;
	
    -- sprawdza czy zespół ma urządzenie wiertnicze
    declare @msg2 varchar(50) = 'Zespół nr ' + cast(@team_id as varchar) + ' nie ma urządzenia'
    if dbo.f_descriptor(@team_id) is NULL
        throw 50002, @msg2, 1;

	-- sprawdza czy w zadeklarowanym przedziale istnieją jakieś punkty do wiercenia w tabeli Theory
	if not exists (select * 
				   from Theory 
				   where drilling_date is null 
				         and station between @start and @end)
		throw 50003, 'W podanym zakresie nie ma punktów do wiercenia', 1;


    declare @ur varchar(2) = dbo.f_descriptor(@team_id)

    -- anulowanie zaplanowanych punktów jeśli nie zostały jeszcze wywiercone.
    -- tylko punkty przeznaczone na urzadzenie, którym dysponuje wiertacz. 
	update planning
	set canceled = 1
	where station in 
		(select station from theory 
		 where station between @start and @end 
			   and Descriptor =  @ur
			   and drilling_date is null
               and done is null)

    -- wstawienie nowych rekordów do tabeli planning
    insert into Planning (station, team_id)
    select 
        station,
        @team_id
    from 
        Theory
    where
        station BETWEEN @start and @end
        and Descriptor = @ur
        and drilling_date is null;
END;
GO
/****** Object:  StoredProcedure [dbo].[p_remove_theory]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[p_remove_theory]
-- służy do usuwania z theory wszystkich niewywierconych punktów.
-- musi być wywołana za każdym razem kiedy jest aktualizowana tabela.
-- punkty mogą być całkowicie anulowane, usuwane z planu do wiercenia.
AS
BEGIN
    begin TRY
        begin TRAN
            -- wyczyszczenie tabeli old_plan
            delete from old_plan;
            -- usunięcie nie wierconych punktów
            -- trigger na tabeli planning wypełnia tabelę old_plan
            delete from Theory where drilling_date is null;
        commit;
    end TRY
    begin CATCH
        if @@trancount >= 1
            ROLLBACK;
            THROW;
    end CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[p_show_team_plan]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[p_show_team_plan]
@name varchar(50)
as
begin
	-- sprawdza czy istnieje brygadzista o podanym imieniu i nazwisku, korzysta z widoku VW_team_leaders
	declare @msg1 varchar(50) = @name + ' nie istnieje lub nie ma brygady!';
	if not exists (select * from VW_team_leaders where Brygadzista = @name)
		throw 50001, @msg1, 1;

	select * from Planning 
	where team_id = (select team_id 
					 from VW_team_leaders 
					 where Brygadzista = @name)
		  and done is null 
		  and canceled = 0;
end;
GO
/****** Object:  StoredProcedure [dbo].[p_temp_plan]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[p_temp_plan]
    @station int
AS
BEGIN
    drop table if EXISTS #plan;

    select * into #plan from Planning where station = @station;
END;
GO
/****** Object:  StoredProcedure [dbo].[p_update_driller_position]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create    procedure [dbo].[p_update_driller_position]
@driller_id int,
@position int
as
begin
    -- sprawdzenie czy istnieje wiertacz o podanym id
    declare @msg varchar(80) = 'Wiertacz o numerze ' + cast(@driller_id as varchar) 
                            + ' nie istnieje.';
    
    if not exists (select * from Drillers where id = @driller_id)
        throw 50001, @msg, 1;
    
    -- sprawdzenie czy wiertacz nie jest obecnie na tej samej pozycji
        declare @old_position int 
        set @old_position = (select post_id 
                            from PositionDetails 
                            where driller_id = @driller_id and date_to is null)
        
        if @position = @old_position
            throw 50002, 'Wiertacz zajmuje już tą pozycję.', 1;
    begin try
        begin transaction
            -- 'usuniecie' poprzedniej pozycji wiertacza - wypełnienie date_to
            
            update PositionDetails
            set date_to = GETDATE()
            where date_to is null and driller_id = @driller_id;
            
            -- dodanie nowego wpisu
            insert into PositionDetails(driller_id, post_id)
            values (@driller_id, @position)
        commit;
    end try
    begin catch
        if @@TRANCOUNT >= 1
            rollback;
            throw;
    end catch;
end;
GO
/****** Object:  StoredProcedure [dbo].[p_update_theory]    Script Date: 18.04.2024 23:14:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create    procedure [dbo].[p_update_theory]
-- procedura służy do aktualizacji tabeli theory
-- zanim zostanie urucomiona, tabela theory musi zostać wyczyszczona przez usunięcie 
-- z tabeli wszystkich punktów, które nie są wywiercone.

@station int,
@descriptor char(30),
@lat decimal(8, 6),
@long decimal(9, 6),
@survey_date DATE
AS
BEGIN   
    -- dzięki on delete cascade w tabeli planning - usunięcie wpisów juz zrelizowanych lub anulowanycyh
    
    -- szukanie punktów wywierconych, które muszą być podmienione.
    if exists (select * from Theory where Station = @station and drilling_date is not null)
        begin TRY
            begin TRAN
                -- usuniecie wpisu z tabeli theory.             
                delete from Theory where Station = @station;
                -- dopisanie wpisu do tabeli theory
                insert into Theory (Station, Descriptor, WGS_Latitude, WGS_Longitude, survey_date)
                values (@station, @descriptor, @lat, @long, @survey_date)
            COMMIT;
        end TRY
        begin CATCH
            if @@TRANCOUNT >= 1
                ROLLBACK;
                THROW;
        end CATCH
    ELSE
        begin TRY
            begin TRAN
                delete from Theory where Station = @station;
                -- dopisanie punktu do tabeli theory                
                insert into Theory (Station, Descriptor, WGS_Latitude, WGS_Longitude, survey_date)
                values (@station, @descriptor, @lat, @long, @survey_date)
                
                begin TRAN
                -- sprawdzenie czy zadany punkt był już planowany, jeśli tak i punkt ciągle jest do wiercenia przepisanie go do aktualnego planu
                    if exists (select * from old_plan where station = @station) and @descriptor in ('xt', 'xr')
                        insert into planning (station, team_id, add_date, expire_date)
                        select station, team_id, add_date, expire_date from old_plan
                        where station = @station;

                    delete from old_plan where station = @station;
                commit;
            commit;
        end try
        begin catch 
            if @@trancount >= 1
                rollback;
                throw;
        end catch
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK_drillers' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Attendance', @level2type=N'COLUMN',@level2name=N'driller_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'point number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Boreholes', @level2type=N'COLUMN',@level2name=N'Station'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Boreholes', @level2type=N'COLUMN',@level2name=N'depth_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Boreholes', @level2type=N'COLUMN',@level2name=N'depth_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Boreholes', @level2type=N'COLUMN',@level2name=N'depth_3'
GO
