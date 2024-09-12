// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains installed applications.
/// </summary>
table 2000000400 "Inplace Installed Application"
{
    Caption = 'Inplace Installed Application';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    InherentEntitlements = Rimdx;

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
        /// The Emit version
        /// </summary>
        field(2; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }

        /// <summary>
        /// The identifier context of inplace publishing
        /// </summary>
        field(3; ID; Guid)
        {
            Caption = 'ID';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID", "Emit Version", ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

