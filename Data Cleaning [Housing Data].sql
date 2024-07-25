--Cleaning Data in SQL Queries

SELECT [SaleDate]
FROM [dbo].[Housingdata]

ALTER TABLE [dbo].[Housingdata]
ADD Saledate2 DATE

UPDATE [dbo].[Housingdata]
SET Saledate2 = CONVERT(DATE,[SaleDate])

SELECT [Saledate2]
FROM [dbo].[Housingdata]

--Populate Property address data

Select *
From [Portfolio Project]..Housingdata
Where PropertyAddress is null
order by ParcelID



Select a.[UniqueID ],a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..Housingdata a
JOIN [Portfolio Project]..Housingdata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..Housingdata a
JOIN [Portfolio Project]..Housingdata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select [PropertyAddress]
From [Portfolio Project]..Housingdata

SELECT 
SUBSTRING([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1) as Address 
,
SUBSTRING([PropertyAddress], CHARINDEX(',',[PropertyAddress])+1, LEN([PropertyAddress])) as City
From [Portfolio Project]..Housingdata

ALTER TABLE [dbo].[Housingdata]
ADD SplitAddress Nvarchar(255), SplitCity Nvarchar(255);

UPDATE [dbo].[Housingdata]
SET [SplitAddress] = SUBSTRING([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1)

UPDATE [dbo].[Housingdata]
SET [SplitCity] = SUBSTRING([PropertyAddress], CHARINDEX(',',[PropertyAddress])+1, LEN([PropertyAddress]))

SELECT [SplitAddress], [SplitCity]
FROM [dbo].[Housingdata]


--Another Way

ALTER TABLE [dbo].[Housingdata]
ADD Owner_Address_Updated Nvarchar(255)

UPDATE [dbo].[Housingdata]
SET [Owner_Address_Updated] = REPLACE([OwnerAddress], ',','.')

--SELECT [Owner_Address_Updated]
--FROM [dbo].[Housingdata]


SELECT
PARSENAME([Owner_Address_Updated], 1) as Parseddata
FROM [dbo].[Housingdata]


ALTER TABLE 
[dbo].[Housingdata]
ADD SplitSate Nvarchar(255)

UPDATE [dbo].[Housingdata]
SET [SplitSate] = PARSENAME([Owner_Address_Updated], 1)

SELECT [SplitSate]
FROM [dbo].[Housingdata]

--Easy Way
--Cleaned data of (Address, City, State)

SELECT 
PARSENAME ([Owner_Address_Updated],3) as Address, 
PARSENAME ([Owner_Address_Updated],2) as City,
PARSENAME ([Owner_Address_Updated],1) as State
FROM [dbo].[Housingdata]

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct([SoldAsVacant]), COUNT([SoldAsVacant])
FROM [dbo].[Housingdata]
GROUP BY [SoldAsVacant]
ORDER BY 2


SELECT [SoldAsVacant],
CASE 
 WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
 WHEN [SoldAsVacant] = 'N' THEN 'No'
 ELSE [SoldAsVacant]
 END
FROM [dbo].[Housingdata]

UPDATE [dbo].[Housingdata]
SET [SoldAsVacant] = CASE 
 WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
 WHEN [SoldAsVacant] = 'N' THEN 'No'
 ELSE [SoldAsVacant]
 END



 -- Remove Duplicates

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

From [dbo].[Housingdata]
--order by ParcelID
)
--DELETE 
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[Housingdata]



-- Delete Unused Columns

ALTER TABLE [dbo].[Housingdata]
--DROP COLUMN [OwnerAddress],[TaxDistrict],[PropertyAddress]
DROP COLUMN [SaleDate]

