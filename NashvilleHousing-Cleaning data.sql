select * 
from projectPortfolio.dbo.NashvilleHousing

-- standarzied date format
select saleDate 
from projectPortfolio.dbo.NashvilleHousing

Alter table NashvilleHousing
add saledateConverted date

update NashvilleHousing 
set saledateConverted = convert(date,saleDate)

-- populate property address data
select PropertyAddress 
from projectPortfolio.dbo.NashvilleHousing
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from projectPortfolio.dbo.NashvilleHousing a
join projectPortfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from projectPortfolio.dbo.NashvilleHousing a
join projectPortfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-- breaking out address into indivisual columns (address, city, state)
select 
SUBSTRING(PropertyAddress, 1, CASE WHEN CHARINDEX(',', PropertyAddress) >0 
Then CHARINDEX(',', PropertyAddress) - 1
else 0
End) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2 , LEN(PropertyAddress)) as Address
from 
projectPortfolio.dbo.NashvilleHousing

Alter table NashvilleHousing
add propertySplitAddress nvarchar(255),
propertySplitCity nvarchar(255)

update NashvilleHousing 
set propertySplitAddress = SUBSTRING(PropertyAddress, 1, CASE WHEN CHARINDEX(',', PropertyAddress) >0 
Then CHARINDEX(',', PropertyAddress) - 1
else 0
End)
update NashvilleHousing 
set propertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2 , LEN(PropertyAddress))

select *
from projectPortfolio.dbo.NashvilleHousing

select
PARSENAME(REPLACE(owneraddress, ',','.'), 3)
,PARSENAME(REPLACE(owneraddress, ',','.'), 2)
,PARSENAME(REPLACE(owneraddress, ',','.'), 1)
 from projectPortfolio.dbo.NashvilleHousing

Alter table NashvilleHousing
add ownerSplitAddress nvarchar(255),
ownerSplitCity nvarchar(255),
ownerSplitState nvarchar(255)

update NashvilleHousing 
set ownerSplitAddress = PARSENAME(REPLACE(owneraddress, ',','.'), 3)

update NashvilleHousing 
set ownerSplitCity = PARSENAME(REPLACE(owneraddress, ',','.'), 2)

update NashvilleHousing 
set ownerSplitState = PARSENAME(REPLACE(owneraddress, ',','.'), 1)


select *
from projectPortfolio.dbo.NashvilleHousing

-- change  Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from projectPortfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE
when SoldAsVacant = 1 then 'Yes' 
when SoldAsVacant = 0 then 'No'
	  else SoldAsVacant
	  end
from projectPortfolio.dbo.NashvilleHousing


-- remove duplicates
with RowNumCTE as (
select *, ROW_NUMBER() over(
partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
from projectPortfolio.dbo.NashvilleHousing
)

select *
-- delete
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- delete unused columns
select * 
from projectPortfolio.dbo.NashvilleHousing

Alter Table projectPortfolio.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict,PropertyAddress, SaleDate
