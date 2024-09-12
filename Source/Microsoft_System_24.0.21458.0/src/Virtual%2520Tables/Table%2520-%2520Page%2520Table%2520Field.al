// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000171 "Page Table Field"
{
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Page ID"; Integer)
        {
        }
        /// <summary>
        /// The field index.
        /// </summary>
        field(2; Index; Integer)
        {
        }
        /// <summary>
        /// The field type.
        /// </summary>
        field(3; Type; Option)
        {
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,NotSupported_Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            // This list must stay in sync with NCLOptionMetadataNavTypeField
            OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
        }
        /// <summary>
        /// The field length, if applicable.
        /// </summary>
        field(4; Length; Integer)
        {
        }
        ///<summary>
        /// The caption of the field.
        ///</summary>
        field(5; Caption; Text[80])
        {
        }
        /// <summary>
        /// The status of the field.
        ///</summary>
        field(6; Status; Option)
        {
            OptionMembers = New,Ready,Placed;
            ObsoleteState = Pending;
            ObsoleteReason = 'This is being removed in favor of the Scope field which provides more granular information.';
        }
        /// <summary>
        /// Specifies whether the field is a table field or a page field bound to a table field (true) or a page field bound to an expression (false).
        /// </summary>
        field(7; IsTableField; Boolean)
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This is being removed in favor of the FieldKind field which provides more granular information.';
        }
        /// <summary>
        /// Specifies how the source of the field (page, page extension, table, or table extension) and how it is currently used on the page (not used, hidden, or visible).
        /// </summary>
        field(8; Scope; Option)
        {
            OptionMembers = TableFieldVisibleOnPage,TableFieldHiddenOnPage,TableFieldNotOnPage,TableExtensionFieldVisibleOnPage,TableExtensionFieldHiddenOnPage,TableExtensionFieldNotOnPage,PageFieldVisible,PageFieldHidden,PageExtensionFieldVisible,PageExtensionFieldHidden;
        }
        /// <summary>
        /// The information as a JSON used to build the tooltip.
        /// </summary>
        field(9; Tooltip; Text[2048])
        {
        }
        /// <summary>
        /// The type of field.
        /// </summary>
        field(10; FieldKind; Option)
        {
            OptionMembers = TableField,PageFieldBoundToTable,PageFieldBoundToExpression;
        }
        /// <summary>
        /// The field name.
        /// </summary>
        field(11; Name; Text[256])
        {
        }
        /// <summary>
        /// The field ID. This represents the field ID for table field and the runtime control ID for page fields.
        /// </summary>
        field(12; "Field ID"; Integer)
        {
        }
    }

    keys
    {
        key(pk; "Page ID", Index)
        {
        }
    }

    fieldGroups
    {
        fieldgroup("Brick"; Type, Caption, Status, Scope)
        {
        }
    }
}