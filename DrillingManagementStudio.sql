USE [u_dojurkow]
GO
/****** Object:  Table [dbo].[InUse]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[Drillers]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drillers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](10) NOT NULL,
	[last_name] [nvarchar](20) NOT NULL,
	[phone] [char](12) NULL,
	[team_id] [int] NULL,
 CONSTRAINT [PK_Drillers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RigTypes]    Script Date: 15.03.2024 16:29:45 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teams]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[Rigs]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  View [dbo].[VW_team_leaders]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_team_leaders]
as
select 
	t.id as team_id
	, d.first_name + ' ' + d.last_name as Brygadzista
	, d.phone
	, tp.eq_type + ' ' + r.inventory_no as Urzadzenie
from Teams t 
	join Drillers d on t.leader_id = d.id
	join InUse i on d.team_id = i.team_id
	join Rigs r on i.rig_id = r.id
	join RigTypes tp on tp.id = r.type_id;
GO
/****** Object:  Table [dbo].[Planning]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  View [dbo].[VW_Plan_punkty]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_Plan_punkty]
as
select p.station, tl.team_id, tl.Brygadzista, tl.Urzadzenie, expire_date 
from Planning p join VW_Team_leaders tl on p.team_id = tl.team_id
where canceled = 0 and done is null;
GO
/****** Object:  View [dbo].[VW_Plan_Brygady]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VW_Plan_Brygady]
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
/****** Object:  Table [dbo].[Attendance]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  View [dbo].[VW_attendance_report]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VW_attendance_report]
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
/****** Object:  Table [dbo].[Boreholes]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Boreholes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Station] [int] NOT NULL,
	[depth_1] [decimal](4, 1) NOT NULL,
	[depth_2] [decimal](4, 1) NULL,
	[depth_3] [decimal](4, 1) NULL,
	[pipe_1] [decimal](4, 1) NOT NULL,
	[pipe_2] [decimal](4, 1) NULL,
	[pipe_3] [decimal](4, 1) NULL,
	[bags] [tinyint] NOT NULL,
	[lithology] [nvarchar](124) NULL,
	[team_id] [int] NOT NULL,
	[drilling_date] [date] NOT NULL,
	[remarks] [nvarchar](124) NULL,
	[WGS_Latitude] [decimal](8, 6) NULL,
	[WGS_Longitude] [decimal](9, 6) NULL,
	[redrill] [bit] NOT NULL,
	[VP_to_SP] [bit] NOT NULL,
 CONSTRAINT [PK_Boreholes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Failures]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[Fuel]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[PositionDetails]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[Positions]    Script Date: 15.03.2024 16:29:45 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Removal]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[Theory]    Script Date: 15.03.2024 16:29:45 ******/
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
/****** Object:  Table [dbo].[WorkHours]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkHours](
	[id] [tinyint] IDENTITY(1,1) NOT NULL,
	[hours] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NULL,
 CONSTRAINT [PK_WorkHours] PRIMARY KEY CLUSTERED 
(
	[id] ASC
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
ALTER TABLE [dbo].[WorkHours] ADD  CONSTRAINT [DF_WorkHours_start_date]  DEFAULT (CONVERT([date],getdate())) FOR [start_date]
GO
ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD  CONSTRAINT [FK_Attendance_Drillers] FOREIGN KEY([driller_id])
REFERENCES [dbo].[Drillers] ([id])
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
GO
ALTER TABLE [dbo].[Boreholes] CHECK CONSTRAINT [FK_Boreholes_Theory]
GO
ALTER TABLE [dbo].[Drillers]  WITH CHECK ADD  CONSTRAINT [FK_Drillers_Teams] FOREIGN KEY([team_id])
REFERENCES [dbo].[Teams] ([id])
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
GO
ALTER TABLE [dbo].[Planning] CHECK CONSTRAINT [FK_Plan_Theory]
GO
ALTER TABLE [dbo].[PositionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PositionDetails_Drillers] FOREIGN KEY([driller_id])
REFERENCES [dbo].[Drillers] ([id])
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
ALTER TABLE [dbo].[Teams]  WITH CHECK ADD  CONSTRAINT [FK_Teams_Drillers] FOREIGN KEY([leader_id])
REFERENCES [dbo].[Drillers] ([id])
GO
ALTER TABLE [dbo].[Teams] CHECK CONSTRAINT [FK_Teams_Drillers]
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
ALTER TABLE [dbo].[Drillers]  WITH CHECK ADD  CONSTRAINT [CK_Drillers] CHECK  (([phone] like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Drillers] CHECK CONSTRAINT [CK_Drillers]
GO
ALTER TABLE [dbo].[Fuel]  WITH CHECK ADD  CONSTRAINT [CK_Fuel] CHECK  (([amount]>(0)))
GO
ALTER TABLE [dbo].[Fuel] CHECK CONSTRAINT [CK_Fuel]
GO
ALTER TABLE [dbo].[WorkHours]  WITH CHECK ADD  CONSTRAINT [CK_WorkHours] CHECK  (([hours]=(12) OR [hours]=(11) OR [hours]=(10) OR [hours]=(9) OR [hours]=(8)))
GO
ALTER TABLE [dbo].[WorkHours] CHECK CONSTRAINT [CK_WorkHours]
GO
/****** Object:  StoredProcedure [dbo].[p_plan_brygady]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[p_plan_brygady]
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
/****** Object:  StoredProcedure [dbo].[p_team_plan]    Script Date: 15.03.2024 16:29:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create   proc [dbo].[p_team_plan]
@name varchar(50), --imie i nazwisko brygadzisty
@start int, --początek przedziału do przeszukiwania tabeli theory 
@end int  --koniec przedziału do przeszukiwania tabeli theory
as
begin
	-- sprawdza czy istnieje brygadzista o podanym imieniu i nazwisku, korzysta z widoku VW_team_leaders
	declare @msg1 varchar(50) = @name + ' nie istnieje lub nie ma brygady!';
	if not exists (select * from VW_team_leaders where Brygadzista = @name)
		throw 50001, @msg1, 1;
	
	-- sprawdza czy w zadeklarowanym przedziale istnieją jakieś punkty do wiercenia w tabeli Theory
	if not exists (select * 
				   from Theory 
				   where drilling_date is null 
				         and station between @start and @end)
		throw 50002, 'W podanym zakresie nie ma punktów do wiercenia', 1;

	-- zmienna potrzebna do wyszukania właściwych punktów w tabeli Theory, na etapie tyczenia jest deklarowana tylko metoda wiercenia
	-- (ręcznie 'xr' lub traktor 'xt'), jedynie 'PAT' jest urządzeniem zamontowanym na traktorze, inne urządzenia to metoda ręczna
	-- urządzenie jest przypisane do danego wiertacza
	declare @ur varchar(2) 
	set @ur = (select case
						when Urzadzenie like 'PAT%' then 'xt'
						else 'xr'
						end
				from VW_team_leaders where Brygadzista = @name);
	
	-- anulowanie zaplanowanych punktów jeśli nie zostały jeszcze wywiercone.
	update planning
	set canceled = 1
	where station in 
		(select station from theory 
		 where station between @start and @end 
			   and Descriptor = @ur 
			   and drilling_date is null) 
		and done is null;
	
	-- wstawienie nowych rekordów (plan)
	insert planning (station, team_id)
	select 
		station,
		(select team_id from VW_team_leaders where Brygadzista = @name)
	from 
		theory
	where
		station between @start and @end 
		and Descriptor = @ur
		and drilling_date is null;
end;
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'between 8 and 12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WorkHours', @level2type=N'CONSTRAINT',@level2name=N'CK_WorkHours'
GO
