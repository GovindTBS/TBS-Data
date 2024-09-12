// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains published applications.
/// </summary>
table 2000000206 "Published Application"
{
    Caption = 'Published Application';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        /// <summary>
        /// The runtime package identifier. Is uniquely generated for each publish event.
        /// </summary>
        field(1; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
        }
        /// <summary>
        /// The package identifier. Belongs to the input package and is uniquely generated upon compiling.
        /// </summary>
        field(2; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        /// <summary>
        /// The app identifier. Should uniquely identify the application and remains static across versions.
        ///  Also is not modified after name and publisher rebranding.
        /// </summary>
        field(3; "ID"; Guid)
        {
            Caption = 'ID';
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
        /// The major version.
        /// </summary>
        field(6; "Version Major"; Integer)
        {
            Caption = 'Version Major';
        }
        /// <summary>
        /// The minor version.
        /// </summary>
        field(7; "Version Minor"; Integer)
        {
            Caption = 'Version Minor';
        }
        /// <summary>
        /// The build version.
        /// </summary>
        field(8; "Version Build"; Integer)
        {
            Caption = 'Version Build';
        }
        /// <summary>
        /// The revision version.
        /// </summary>
        field(9; "Version Revision"; Integer)
        {
            Caption = 'Version Revision';
        }
        /// <summary>
        /// The package type. Indicates which package type the application is.
        /// </summary>
        field(10; "Package Type"; Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Extension,Symbols only,Designer';
            OptionMembers = Extension,SymbolsOnly,Designer;
        }
        /// <summary>
        /// The "Published As" option. Indicates how the application was published.
        /// </summary>
        field(11; "Published As"; Option)
        {
            Caption = 'Published As';
            OptionCaption = 'Global, PTE, Dev';
            OptionMembers = "Global","PTE","Dev";
        }
        /// <summary>
        /// The tenant identifier. Is empty for global applications but filled in for
        /// PTEs (per-tenant extensions) or DEV extensions.
        /// </summary>
        field(12; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        /// <summary>
        /// Indicates if the application is installed or not.
        /// </summary>
        field(13; Installed; Boolean)
        {
            CalcFormula = Exist("Installed Application" WHERE("Runtime Package ID" = FIELD("Runtime Package ID")));
            Caption = 'Installed';
            FieldClass = FlowField;
        }
        /// <summary>
        /// A short description of the application.
        /// </summary>
        field(14; Brief; Text[250])
        {
            Caption = 'Brief';
        }
        /// <summary>
        /// A description of the application.
        /// </summary>
        field(15; Description; BLOB)
        {
            Caption = 'Description';
        }
        /// <summary>
        /// A URL pointing to the application's privacy statement.
        /// </summary>
        field(16; "Privacy Statement"; Text[250])
        {
            Caption = 'Privacy Statement';
        }
        /// <summary>
        /// A URL pointing to the application's end-user license agreement.
        /// </summary>
        field(17; EULA; Text[250])
        {
            Caption = 'EULA';
        }
        /// <summary>
        /// A URL pointing to the application's website.
        /// </summary>
        field(18; Url; Text[250])
        {
            Caption = 'Url';
        }
        /// <summary>
        /// A URL pointing a website containing support or help documentation for the application.
        /// </summary>
        field(19; Help; Text[250])
        {
            Caption = 'Help';
        }
        /// <summary>
        /// The application's logo.
        /// </summary>
        field(20; Logo; Media)
        {
            Caption = 'Logo';
        }
        /// <summary>
        /// Screenshots of the application.
        /// </summary>
        field(21; Screenshots; MediaSet)
        {
            Caption = 'Screenshots';
        }
        /// <summary>
        /// The package BLOB of the application.
        /// </summary>
        field(22; Blob; BLOB)
        {
            Caption = 'Blob';
        }
        /// <summary>
        /// The application's response URL.
        /// </summary>
        field(23; responseUrl; Text[250])
        {
            Caption = 'responseUrl';
            FieldClass = FlowField;
        }
        /// <summary>
        /// The application's request identifier.
        /// </summary>
        field(24; requestId; Text[250])
        {
            Caption = 'requestId';
            FieldClass = FlowField;
        }
        /// <summary>
        /// The application's symbols.
        /// </summary>
        field(25; Symbols; BLOB)
        {
            Caption = 'Symbols';
        }
        /// <summary>
        /// The application's content hash.
        /// </summary>
        field(26; "Content Hash"; Text[250])
        {
            Caption = 'Content Hash';
        }
        /// <summary>
        /// A field indicating whether or not the source code of this application is shown during debugging.
        /// </summary>
        field(27; "Show My Code"; Boolean)
        {
            Caption = 'Show My Code';
        }
        /// <summary>
        /// The application package's hash.
        /// </summary>
        field(28; "Package Hash"; Text[64])
        {
            Caption = 'Package Hash';
        }
        /// <summary>
        /// The application's "Azure Application Insights" key for custom telemetry.
        /// </summary>
        field(29; "Application Insights Key"; Guid)
        {
            Caption = 'Application Insights Key';
            ObsoleteState = Pending;
            ObsoleteReason = 'This field has been replaced by the field "App Insights Connection String". Visit the following for more info: https://learn.microsoft.com/en-us/azure/azure-monitor/app/sdk-connection-string?tabs=net.';
        }

        // TODO (pteisolation) Ask application team if it is possible to set filters to express
        // Published As == Global || ((Published As == PTE || Published As == DEV) && Tenant ID == 'x')
        /// <summary>
        /// A field indicating whether this application is visible to the tenant.
        /// </summary>
        field(30; "Tenant Visible"; Boolean)
        {
            CalcFormula = Lookup("NAV App Extra"."Tenant Visible" WHERE("Runtime Package ID" = FIELD("Runtime Package ID")));
            Caption = 'Tenant Visible';
            FieldClass = FlowField;
        }

        // TODO (pteisolation) Ask application team if it is possible to set filters to express
        // (Published As == Global AND is installed for the tenant) || ((Published As == PTE || Published As == DEV) && Tenant ID == 'x')
        /// <summary>
        /// A field indicating whether this application is a PTE or if it is a Global application that is installed for the tenant.
        /// </summary>
        field(31; "PerTenant Or Installed"; Boolean)
        {
            CalcFormula = Lookup("NAV App Extra"."PerTenant Or Installed" WHERE("Runtime Package ID" = FIELD("Runtime Package ID")));
            Caption = 'PerTenant Or Installed';
            FieldClass = FlowField;
        }

        /// <summary>
        /// A comma-separated list of URLs for the key vaults that contain the app's secrets.
        /// </summary>
        field(32; "Key Vault URLs"; Text[250])
        {
            Caption = 'Key Vault URLs';
        }

        /// <summary>
        /// The AAD tenant ID of the app publisher.
        /// </summary>
        field(33; "Publisher AAD Tenant ID"; Guid)
        {
            Caption = 'Publisher AAD Tenant ID';
        }

        /// <summary>
        /// The documentation of the application.
        /// </summary>
        field(34; Documentation; BLOB)
        {
            Caption = 'Documentation';
        }

        /// <summary>
        /// A connection string for an Application Insights resource. Takes presedence over Application Insights Key
        /// </summary>
        field(35; "App Insights Connection String"; Text[512])
        {
            Caption = 'Application Insights Connection String';
        }

        /// <summary>
        /// Resource Exposure Policy defines an application intelectual property protection policy.
        /// </summary>
        field(36; "Resource Exposure Policy"; Integer)
        {
            Caption = 'Resource Exposure Policy';
        }

        /// <summary>
        /// Resource Exposure Policy Applicable To Dev Extension specifies if the Resource Exposure Policy should also be enforced on DEV extensions
        /// </summary>
        field(37; "Resource Exposure Policy Applicable To Dev Extension"; Boolean)
        {
            Caption = 'Resource Exposure Policy Applicable To Dev Extension';
        }
    }

    keys
    {
        key(Key1; "Runtime Package ID")
        {
            Clustered = true;
        }
        key(Key2; "Package ID", "Tenant ID")
        {
        }
        key(Key3; Name)
        {
        }
        key(Key4; Publisher)
        {
        }
        key(Key5; Name, "Version Major", "Version Minor", "Version Build", "Version Revision")
        {
        }
        key(Key6; ID)
        {
        }
    }

    fieldgroups
    {
        // The "Description" field is a placeholder to move "Brief"
        // on a new line in the page when view is Tiles or 'Tall tiles'
        fieldgroup(Brick; Publisher, Name, Logo, Description, Brief)
        {
        }
    }
}

