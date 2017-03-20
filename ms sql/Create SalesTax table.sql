USE [jcp]
GO

/****** Object:  Table [dbo].[SalesTaxRate]    Script Date: 3/19/2017 9:04:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SalesTaxRate](
	[salesTaxID] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[rate] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_SalesTaxRate] PRIMARY KEY CLUSTERED 
(
	[salesTaxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


