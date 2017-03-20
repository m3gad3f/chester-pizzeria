USE [jcp]
GO

/****** Object:  Table [dbo].[OrderLineItem]    Script Date: 3/19/2017 9:04:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OrderLineItem](
	[lineItemID] [int] IDENTITY(1,1) NOT NULL,
	[itemID] [int] NOT NULL,
	[orderID] [int] NOT NULL,
	[qty] [int] NOT NULL,
	[price] [decimal](18, 2) NULL,
	[extendedPrice] [decimal](18, 2) NULL,
 CONSTRAINT [PK_OrderLineItem] PRIMARY KEY CLUSTERED 
(
	[lineItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[OrderLineItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderLineItem_Item] FOREIGN KEY([itemID])
REFERENCES [dbo].[Item] ([itemID])
GO

ALTER TABLE [dbo].[OrderLineItem] CHECK CONSTRAINT [FK_OrderLineItem_Item]
GO

ALTER TABLE [dbo].[OrderLineItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderLineItem_Order] FOREIGN KEY([orderID])
REFERENCES [dbo].[Order] ([orderID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[OrderLineItem] CHECK CONSTRAINT [FK_OrderLineItem_Order]
GO


