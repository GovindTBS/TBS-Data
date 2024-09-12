// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains the dependency relationship between published applications.
/// </summary>
table 2000000209 "Application Dependency"
{
    Caption = 'Application Dependency';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        /// <summary>
        /// The runtime package identifier for the dependent app.
        /// </summary>
        field(1; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
        }
        /// <summary>
        /// The package identifier for the dependent app.
        /// </summary>
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        /// <summary>
        /// The dependency's application identifier.
        /// </summary>
        field(3; "Dependency App ID"; Guid)
        {
            Caption = 'Dependency App ID';
        }
        /// <summary>
        /// The dependency's application name.
        /// </summary>
        field(4; "Dependency Name"; Text[250])
        {
            Caption = 'Dependency Name';
        }
        /// <summary>
        /// The dependency's application publisher.
        /// </summary>
        field(5; "Dependency Publisher"; Text[250])
        {
            Caption = 'Dependency Publisher';
        }
        /// <summary>
        /// The dependency's application major version.
        /// </summary>
        field(6; "Dependency Version Major"; Integer)
        {
            Caption = 'Dependency Version Major';
        }
        /// <summary>
        /// The dependency's application minor version.
        /// </summary>
        field(7; "Dependency Version Minor"; Integer)
        {
            Caption = 'Dependency Version Minor';
        }
        /// <summary>
        /// The dependency's application build version.
        /// </summary>
        field(8; "Dependency Version Build"; Integer)
        {
            Caption = 'Dependency Version Build';
        }
        /// <summary>
        /// The dependency's application revision version.
        /// </summary>
        field(9; "Dependency Version Revision"; Integer)
        {
            Caption = 'Dependency Version Revision';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID", "Dependency App ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

