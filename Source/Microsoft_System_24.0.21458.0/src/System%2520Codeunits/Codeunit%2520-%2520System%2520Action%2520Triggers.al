// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

using System.Reflection;

codeunit 2000000006 "System Action Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetDefaultRoleCenterID(var ID: Integer)
    begin
    end;

    [InternalEvent(false)]
    procedure GetRoleCenterBannerPartID(var PartID: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure CustomizeChart(var TempChart: Record Chart temporary; var LookupOK: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenSettings()
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenContactMSSales()
    begin
    end;

    [BusinessEvent(false)]
    [Obsolete('Support for the classic debugger engine has been removed.')]
    procedure OpenDebugger()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnEditInExcel(ServiceName: Text[240]; ODataFilter: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnOpenInExcel(Location: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnEditInExcelWithSearchString(ServiceName: Text[240]; ODataFilter: Text; SearchString: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnEditInExcelWithStructuredFilter(ServiceName: Text[240]; SearchString: Text; Filter: JsonObject; Payload: JsonObject)
    begin
    end;

    [BusinessEvent(false)]
    procedure InvokeExtensionInstallation(AppId: Text; ResponseUrl: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenLastErrorPage()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetSupportInformation(var Name: Text; var Email: Text; var Url: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure SetNotificationStatus(NotificationId: Guid; Enable: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetNotificationStatus(NotificationId: Guid; var IsEnabled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure ChangeCompany(var NewCompanyName: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenRoleBasedSetupExperience()
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenGeneralSetupExperience()
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenAppSourceMarket()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetAutoStartTours(var IsEnabled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetIsLegacyActionBarEnabled(var IsEnabled: Boolean)
    begin
    end;

    [Scope('OnPrem')]
    [NonDebuggable]
    [BusinessEvent(false)]
    procedure GetUserToken(Resource: Text; Scenario: Text; var Token: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure ConfirmPrivacyNoticeApproval(PrivacyNoticeIntegrationName: Text; var IsApproved: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetPrivacyNoticeApprovalState(PrivacyNoticeIntegrationName: Text; var PrivacyNoticeApprovalState: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetPowerPlatformEnvironmentId(Scenario: Text; var EnvironmentId: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetPerformanceTroubleshooterPageId(var PageId: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetFindEntriesPageId(var PageId: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetDataSearchPageId(var PageId: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenDataSearchPage(SearchValue: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetCopilotCapabilityStatus(Capability: Integer; var IsEnabled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetDataSearchSetup(var SetupInfo: JsonArray)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetDisplayPageId(TableNo: Integer; SystemId: Guid; var DisplayPageId: Integer; var DisplayTableNo: Integer; var DisplaySystemId: Guid)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnCopilotFeedbackProperties(CustomDimensions: JsonObject)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnCopilotSystemActionInvokedProperties(CustomDimensions: JsonObject)
    begin
    end;
}
