
--Cleaning Data in SQL Queries

Select *
From NashvilleHousing

--Standarize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashVilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


-------------------------------------------------------------------------------------------------

--Populate Property Address data

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

Update a
SET PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From NashvilleHousing


ALTER TABLE NashVilleHousing
Add PropertySplitAddress NVARCHAR(225);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashVilleHousing
Add PropertySplitCity NVARCHAR(225);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))




Select *
From NashvilleHousing




Select OwnerAddress
From NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
From NashvilleHousing


ALTER TABLE NashVilleHousing
Add OwnerSplitAddress NVARCHAR(225);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashVilleHousing
Add OwnerSplitCity NVARCHAR(225);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE NashVilleHousing
Add OwnerSplitState NVARCHAR(225);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashVilleHousing
Group by SoldAsVacant
order by 2 DESC



Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From NashVilleHousing


Update NashVilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates 

WITH RowNumCTE AS(
Select *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By
				UniqueID
				) row_num


From NashVilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num>1
Order By PropertyAddress

--Deleting Duplicates

WITH RowNumCTE AS(
Select *,
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By
				UniqueID
				) row_num


From NashVilleHousing

)
DELETE
From RowNumCTE
Where row_num>1



--Delete Unused Columns

Select *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate