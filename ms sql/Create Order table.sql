USE [jcp]
GO

/****** Object:  Table [dbo].[Order]    Script Date: 3/19/2017 9:15:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[orderNumber] [int] NULL,
	[subTotal] [decimal](18, 2) NOT NULL,
	[totalTax] [decimal](18, 2) NOT NULL,
	[grandTotal] [decimal](18, 2) NOT NULL,
	[timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_timestamp]  DEFAULT (getdate()) FOR [timestamp]
GO


