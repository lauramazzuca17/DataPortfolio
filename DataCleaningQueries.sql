-- Data cleaning in SQL queries 

Select * From Nashville.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Standardizing Date Format

Select SaleDateConverted, Convert(Date,SaleDate)
From Nashville.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------------------------------

-- Populating property address data by using the ParcelID to find and fill missing addresses

Select * From Nashville.dbo.NashvilleHousing
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------

-- Splitting Address into individual columns (Address, City, State)

-- Property Address using substring
Select PropertyAddress
From Nashville.dbo.NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
From Nashville.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



-- Owner Address using parsename
Select OwnerAddress
From Nashville.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From Nashville.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


---------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "sold as vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashville.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant, 
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
From Nashville.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END


---------------------------------------------------------------------------------------------------------

-- Remove duplicates (in most cases I use a temp table when removing duplicates instead of deleting from my database)

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

From Nashville.dbo.NashvilleHousing
--order by UniqueID
)
DELETE
From RowNumCTE
Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns (don't do this to your raw data)

Select *
From Nashville.dbo.NashvilleHousing

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN SaleDate
