Create database HOUSING
use HOUSING

select * 
From NashvilleHousing

/* PROJECT WALK THOUGH */
	-- 1. Standardize Date Format
	-- 2. Populate Property Address data
	-- 3. Breaking out Address into Individual Columns (Address, City, State)
	-- 4. Change Y and N to Yes and No in "Sold as Vacant" field
	-- 5. Remove Duplicates
	-- 6. Delete Unused Columns


/* FUNCTION USED */
	-- CONVERT, ISNULL
	-- ALTER/UPDATE TABLE, DROP COLUMN 
	-- SUBSTRING, CHARINDEX, LEN, PARSENAME, REPLACE
	-- CTE



-- 1. Standardize Date Format
	select SaleDate, CONVERT(date,SaleDate) As sale_date_converted
	From NashvilleHousing

	Alter Table NashvilleHousing
	Add sale_date_converted Date
	
	Update NashvilleHousing
	Set sale_date_converted = CONVERT(date,SaleDate)

	Select *
	From NashvilleHousing




-- 2. Populate Property Address data
	Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
	From NashvilleHousing a
	JOIN NashvilleHousing b
		on a.ParcelID=b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null

	Update a
	Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	From NashvilleHousing a
	JOIN NashvilleHousing b
		on a.ParcelID=b.ParcelID
		and a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null

	/* check if any null address*/
	Select *
	From NashvilleHousing
	Where PropertyAddress is null




-- 3. Breaking out Address into Individual Columns (Address, City, State)
		
	/* Add columns PROPERTY and OWNER adress*/ 
	ALTER TABLE NashvilleHousing
	ADD Property_Address varchar(255),
		Property_City varchar(255),
		Owner_Address varchar(255),
		Owner_City varchar(255),
		Owner_State varchar(255);


 
	/* Update columns PROPERTY and OWNER adress*/ 
	Update NashvilleHousing
	Set 
		Property_Address  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
		Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2, len(PropertyAddress)),
		Owner_Address = PARSENAME(Replace(OwnerAddress,',','.'), 3),
		Owner_City = PARSENAME(Replace(OwnerAddress,',','.'), 2),
		Owner_State = PARSENAME(Replace(OwnerAddress,',','.'), 1) 


	/* Check data */ 
	Select *
	From NashvilleHousing




-- 4. Change Y and N to Yes and No in "Sold as Vacant" field
	
	/* checking data*/
	Select Distinct (SoldAsVacant), COUNT(SoldAsVacant) as Count
	From NashvilleHousing
	Group by SoldAsVacant

	/* Testing code to replace Y=Yes, N=No*/
	Select  SoldAsVacant,
			CASE 
			when SoldAsVacant ='N' then 'No'
			when SoldAsVacant = 'Y' then 'Yes'
			else SoldAsVacant
			END
	From NashvilleHousing

	/* Update data, Replace Y=Yes, N=No */
	Update NashvilleHousing
	Set SoldAsVacant = 
		CASE 
		when SoldAsVacant ='N' then 'No'
		when SoldAsVacant = 'Y' then 'Yes'
		else SoldAsVacant
		END		
	
	
		

-- 5. Remove Duplicates

	With RowNumCTE as(
		Select	*,
				ROW_NUMBER() over (
				Partition by ParcelID,
							 PropertyAddress,
							 SalePrice,
							 SaleDate,
							 LegalReference
							 Order by UniqueID
							 ) row_num
						 		
		From NashvilleHousing
		-- Order by ParcelID
	)	
	DELETE
	From RowNumCTE
	Where row_num >1
	-- Order by PropertyAddress





-- 6. Delete Unused Columns (OwnerAddress, TaxDistrict, PropertyAddress, SaleDate)

	Select *
	From NashvilleHousing

	Alter Table NashvilleHousing
	DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate