// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains object metadata from published applications.
/// </summary>
table 2000000207 "Application Object Metadata"
{
    Caption = 'Application Object Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        /// <summary>
        /// The runtime package identifier for the application this object belongs to.
        /// </summary>
        field(1; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
        }
        /// <summary>
        /// The package identifier for the application this object belongs to.
        /// </summary>
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        /// <summary>
        /// The object type.
        /// </summary>
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = ',Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,,,,,PageExtension,TableExtension,Enum,EnumExtension,,,PermissionSet,PermissionSetExtension,ReportExtension';
            OptionMembers = ,"Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query",,,,,"PageExtension","TableExtension","Enum","EnumExtension",,"PermissionSet","PermissionSetExtension","ReportExtension";
        }
        /// <summary>
        /// The object identifier.
        /// </summary>
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        /// <summary>
        /// The object's metadata format.
        /// </summary>
        field(5; "Metadata Format"; Option)
        {
            Caption = 'Metadata Format';
            OptionCaption = 'Full,Delta';
            OptionMembers = Full,Delta;
        }
        /// <summary>
        /// The object's metadata.
        /// </summary>
        field(6; Metadata; BLOB)
        {
            Caption = 'Metadata';
        }
        /// <summary>
        /// The object runtime code.
        /// </summary>
        field(7; "User Code"; BLOB)
        {
            Caption = 'User Code';
        }
        /// <summary>
        /// The object AL code.
        /// </summary>
        field(8; "User AL Code"; BLOB)
        {
            Caption = 'User AL Code';
        }
        /// <summary>
        /// The object metadata version.
        /// </summary>
        field(9; "Metadata Version"; Integer)
        {
            Caption = 'Metadata Version';
        }
        /// <summary>
        /// The object sub type.
        /// </summary>
        field(10; "Object Subtype"; Text[30])
        {
            Caption = 'Object Subtype';
        }
        /// <summary>
        /// The object name.
        /// </summary>
        field(11; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
        }
        /// <summary>
        /// The object metadata's hash.
        /// </summary>
        field(12; "Metadata Hash"; Text[64])
        {
            Caption = 'Metadata Hash';
        }
        /// <summary>
        /// The object runtime code's hash.
        /// </summary>
        field(13; "User Code Hash"; Text[64])
        {
            Caption = 'User Code Hash';
        }
        /// <summary>
        /// The object flags.
        /// </summary>
        field(14; "Object Flags"; Integer)
        {
            Caption = 'Object Flags';
        }

        /// <summary>
        /// The Emit Version field
        /// </summary>
        field(15; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }

        /// <summary>
        /// The object AL source code's hash.
        /// </summary>
        field(16; "User AL Code Hash"; Text[64])
        {
            Caption = 'User AL Code Hash';
        }

        /// <summary>
        /// The object schema hash.
        /// </summary>
        field(17; "Schema Hash"; Integer)
        {
            Caption = 'Schema Hash';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID", "Object Type", "Object ID", "Emit Version")
        {
            Clustered = true;
        }

        key(Key2; "Emit Version")
        {
            Unique = false;
        }
    }

    fieldgroups
    {
    }
}

