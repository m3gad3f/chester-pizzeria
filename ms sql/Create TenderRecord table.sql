USE [jcp]
GO

/****** Object:  Table [dbo].[TenderRecord]    Script Date: 3/19/2017 9:04:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TenderRecord](
	[tenderRecordID] [int] IDENTITY(1,1) NOT NULL,
	[orderID] [int] NOT NULL,
	[amountTendered] [decimal](18, 2) NOT NULL,
	[changeGiven] [decimal](18, 2) NOT NULL,
	[timeStamp] [datetime] NOT NULL,
 CONSTRAINT [PK_TenderRecord] PRIMARY KEY CLUSTERED 
(
	[tenderRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TenderRecord] ADD  CONSTRAINT [DF_TenderRecord_timeStamp]  DEFAULT (getdate()) FOR [timeStamp]
GO

ALTER TABLE [dbo].[TenderRecord]  WITH CHECK ADD  CONSTRAINT [FK_TenderRecord_Order] FOREIGN KEY([orderID])
REFERENCES [dbo].[Order] ([orderID])
GO

ALTER TABLE [dbo].[TenderRecord] CHECK CONSTRAINT [FK_TenderRecord_Order]
GO


