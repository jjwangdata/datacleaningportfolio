/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [WANGS-portfolio-nashvilhousing]

 -- standardize data format
   select saledate,convert(date,saledate) as date
   FROM [WANGS-portfolio-nashvilhousing]

   --missing data   populate data
   select a.[ParcelID],a.uniqueID,a.propertyaddress,b.[ParcelID],b.uniqueID,b.propertyaddress,
   isnull(a.propertyaddress,b.propertyaddress)
   from [WANGS-portfolio-nashvilhousing] a
    join [WANGS-portfolio-nashvilhousing] b
	 on a.[ParcelID]=b.[ParcelID]
	   and a.uniqueID<>b.uniqueID
   where a.propertyaddress is null

   update a
   set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
   from [WANGS-portfolio-nashvilhousing] a
    join [WANGS-portfolio-nashvilhousing] b
	 on a.[ParcelID]=b.[ParcelID]
	   and a.uniqueID<>b.uniqueID
   where a.propertyaddress is null

   --breaking out address

   	 
   Select propertyaddress, SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)as address1,
          SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))as address2
   from [WANGS-portfolio-nashvilhousing]
