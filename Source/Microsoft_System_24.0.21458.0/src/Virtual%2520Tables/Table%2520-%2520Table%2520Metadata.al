// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000136 "Table Metadata"
{
    DataPerCompany = False;
    Scope = Cloud;
    InherentPermissions = rX;

    //WriteProtected=True;
    fields
    {
        field(1; ID; Integer)
        {
        }
        field(2; Name; Text[30])
        {
        }
        field(3; Caption; Text[80])
        {
        }
        field(4; DataPerCompany; Boolean)
        {
        }
        field(5; LookupPageID; Integer)
        {
        }
        field(6; DrillDownPageId; Integer)
        {
        }
        field(7; DataCaptionFields; Text[80])
        {
        }
        field(8; PasteIsValid; Boolean)
        {
        }
        field(9; LinkedObject; Boolean)
        {
        }
        field(10; DataIsExternal; Boolean)
        {
        }
        field(11; TableType; Option)
        {
            OptionMembers = Normal,CRM,ExternalSQL,Exchange,MicrosoftGraph,Query,Temporary;
        }
        field(12; ExternalName; Text[248])
        {
        }
        field(13; ObsoleteState; Option)
        {
            OptionMembers = No,Pending,Removed;
        }
        field(14; ObsoleteReason; Text[248])
        {
        }
        field(15; DataClassification; Option)
        {
            OptionMembers = CustomerContent,ToBeClassified,EndUserIdentifiableInformation,AccountData,EndUserPseudonymousIdentifiers,OrganizationIdentifiableInformation,SystemMetadata;
        }
        field(16; ReplicateData; Boolean)
        {
            Caption = 'ReplicateData';
        }
        field(17; CompressionType; Option)
        {
            OptionMembers = Unspecified,None,Row,Page;
        }
    }
}