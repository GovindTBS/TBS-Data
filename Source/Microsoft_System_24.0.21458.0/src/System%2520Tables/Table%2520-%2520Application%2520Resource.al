// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains the resources of a published application.
/// </summary>
table 2000000208 "Application Resource"
{
    Caption = 'Application Resource';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        /// <summary>
        /// The runtime package identifier for the application this resource belongs to.
        /// </summary>
        field(1; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
        }
        /// <summary>
        /// The package identifier for the application this resource belongs to.
        /// </summary>
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        /// <summary>
        /// The resource type.
        /// </summary>
        field(3; Type; Integer)
        {
            Caption = 'Type';
        }
        /// <summary>
        /// The resource name.
        /// </summary>
        field(4; Name; Text[250])
        {
            Caption = 'Name';
        }
        /// <summary>
        /// The resource content.
        /// </summary>
        field(5; Content; BLOB)
        {
            Caption = 'Content';
        }
        /// <summary>
        /// The resource hash.
        /// </summary>
        field(6; Hash; Text[64])
        {
            Caption = 'Hash';
        }

        /// <summary>
        /// The Emit Version field
        /// </summary>
        field(7; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID", Type, Name, "Emit Version")
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

