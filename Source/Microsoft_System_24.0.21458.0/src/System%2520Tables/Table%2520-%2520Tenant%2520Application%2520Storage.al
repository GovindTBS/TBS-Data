// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains Tenant applications.
/// </summary>
table 2000000239 "Tenant Application Storage"
{
    Caption = 'Tenant Application Storage';
    DataPerCompany = false;
    Scope = OnPrem;
    ReplicateData = false;

    fields
    {
        /// <summary>
        ///  The app identifier. Should uniquely identify the application and remains static across versions.
        ///  Also is not modified after name and publisher rebranding.
        /// </summary>
        field(1; "ID"; Guid)
        {
            Caption = 'ID';
        }

        /// <summary>
        /// Specifies the release that this PTE is staged for.
        /// </summary>
        field(2; "Target Release"; Text[43])
        {
            Caption = 'Target Release';

        }

        /// <summary>
        /// The package identifier. Belongs to the input package and is uniquely generated upon compiling.
        /// </summary>
        field(3; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }

        /// <summary>
        /// The app name. A human-readable name for the application.
        /// </summary>
        field(4; Name; Text[250])
        {
            Caption = 'Name';
        }

        /// <summary>
        /// The app publisher. A human-readable publisher for the application. 
        /// The publisher represents the individual or organization who created or 
        /// currently maintains the application.
        /// </summary>
        field(5; Publisher; Text[250])
        {
            Caption = 'Publisher';
        }

        /// <summary>
        /// The app version.
        /// </summary>
        field(6; Version; Text[43])
        {
            Caption = 'Version';
        }

        /// <summary>
        /// Application version mentioned in the manifes of the app
        /// </summary>
        field(7; ApplicationVersion; Text[43])
        {
            Caption = 'Application Version';
        }

        /// <summary>
        /// A list of dircet dependencies of the app in json format 
        /// </summary>
        field(8; Dependencies; Blob)
        {
            Caption = 'Dependencies';
        }

        /// <summary>
        /// Specifies the sync mode which will be used for synchronizing the app.
        /// </summary>
        field(9; "Sync Mode"; Option)
        {
            Caption = 'Sync Mode';
            OptionMembers = "Add","Force";
        }

        /// <summary>
        /// Indicates if the application is installed or not.
        /// </summary>
        field(10; Installed; Boolean)
        {
            CalcFormula = Exist("Installed Application" WHERE("Package ID" = FIELD("Package ID")));
            Caption = 'Installed';
            FieldClass = FlowField;
        }

        /// <summary>
        /// The package BLOB of the application.
        /// </summary>
        field(11; Blob; BLOB)
        {
            Caption = 'Blob';
        }

        /// <summary>
        /// The application package's hash.
        /// </summary>
        field(13; "Package Hash"; Text[64])
        {
            Caption = 'Package Hash';
        }
    }

    keys
    {
        key(Key1; "Package ID", "Target Release")
        {
            Clustered = true;
        }
        key(Key2; ID)
        {
        }
    }
}

