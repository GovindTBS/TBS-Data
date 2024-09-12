// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains installed applications.
/// </summary>
table 2000000212 "Installed Application"
{
    Caption = 'Installed Application';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        /// <summary>
        /// The runtime package identifier for the installed application's package.
        /// </summary>
        field(1; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
        }
        /// <summary>
        /// The package identifier for the installed application's package.
        /// </summary>
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        /// <summary>
        /// The tenant identifier. Indicates which tenant has installed this application.
        /// </summary>
        field(3; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID", "Tenant ID")
        {
            Clustered = true;
        }
        key(Key2; "Package ID", "Tenant ID")
        {
        }
        key(Key3; "Tenant ID")
        {
        }
    }

    fieldgroups
    {
    }
}

