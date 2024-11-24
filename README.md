# TODO

# Features

## [ ] Data Field - Move ChangeFieldToValue button into DataField menu

## [ ] Implement functionality for ReceiptDataPage menu options

### [ ] Implement remove item option

#### [ ] remove one - "Remove Item"
add remove button for each DataField after choosing option

#### [ ] remove many - "Remove Many"
Add checkbox button for each DataField
Remove checked data fields

### [ ] Implement add item 
Add a new datafield after click (future: there could be an option to choose location for a new data field)

### [ ] Implement save receipt
Add onSaved callback
Parse data fields into Receipt and use onSaved callback

## change colors of FAB

## add loading animation (or "processing" label with jumping dots animation) when image is processing

# BUGS

## [x] receipt wasn't updated after text/value changes:
Steps:
    1. change an entity text
    2. scroll down to hide the entity
    3. scroll back to show the entity

Expected result:
    entity text is still updated

Current result:
    entity text is not updated