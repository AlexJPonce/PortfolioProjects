
SELECT * 
FROM [Portfolio Project ]..NashvilleHousing



--Standardize Date Format

SELECT SaleDate, CONVERT(date,SaleDate)
FROM [Portfolio Project ]..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

SELECT SaleDateConverted
FROM [Portfolio Project ]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populated Property Address data

SELECT *
FROM [Portfolio Project ]..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project ]..NashvilleHousing a
JOIN [Portfolio Project ]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project ]..NashvilleHousing a
JOIN [Portfolio Project ]..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

--Breaking out Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM [Portfolio Project ]..NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS Address

FROM [Portfolio Project ]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM [Portfolio Project ]..NashvilleHousing


SELECT OwnerAddress
FROM [Portfolio Project ]..NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

FROM [Portfolio Project ]..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM [Portfolio Project ]..NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project ]..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
	CASE WHEN SoldASVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM [Portfolio Project ]..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldASVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

--Remove Duplicates

WITH ROWNUMCTE AS (
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM [Portfolio Project ]..NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM ROWNUMCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM [Portfolio Project ]..NashvilleHousing


--Delete Unused Columns


SELECT *
FROM [Portfolio Project ]..NashvilleHousing


ALTER TABLE [Portfolio Project ]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project ]..NashvilleHousing
DROP COLUMN SaleDate


