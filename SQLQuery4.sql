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

--Do type conversion
-- standardize data format

  Select saleDate, CONVERT(Date,SaleDate)
	From [WANGS-portfolio-nashvilhousing]
	
  Update [WANGS-portfolio-nashvilhousing]
  SET SaleDate = CONVERT(Date,SaleDate)



-- Remove duplicate data
	
	WITH RowNumCTE AS(
	Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num
	From [WANGS-portfolio-nashvilhousing]
	Delete
	 RowNumCTE
	Where row_num > 1
	


   --Deal with missing data 
   --populate address data
		
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

		
		
-- Normalize data
--Change Y and N to Yes and No 
	
	Select Distinct(SoldAsVacant), Count(SoldAsVacant)
	From [WANGS-portfolio-nashvilhousing]
	Group by SoldAsVacant
	order by 2
	

	Select SoldAsVacant
	, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		   When SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END
	From [WANGS-portfolio-nashvilhousing]
		
	Update [WANGS-portfolio-nashvilhousing]
	SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		   When SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END

		
   --break out address

   	 
   Select propertyaddress, 
	  SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)as address1,
          SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))as address2
   from [WANGS-portfolio-nashvilhousing]
		
		
		
  -- Remove irrelevant data
	
	

	Select *
	From [WANGS-portfolio-nashvilhousing]
	

	ALTER TABLE [WANGS-portfolio-nashvilhousing]
	DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
