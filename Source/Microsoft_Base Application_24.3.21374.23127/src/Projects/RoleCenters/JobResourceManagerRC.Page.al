namespace Microsoft.Projects.RoleCenters;

using Microsoft.EServices.EDocument;
using Microsoft.Foundation.Navigate;
#if CLEAN23
using Microsoft.Pricing.Worksheet;
#endif
using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Resources.Journal;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Projects.TimeSheet;
#if CLEAN23
using Microsoft.Purchases.Pricing;
#endif
#if not CLEAN23
using Microsoft.RoleCenters;
#endif
using Microsoft.Sales.Customer;
#if CLEAN23
using Microsoft.Sales.Pricing;
#endif
using Microsoft.Service.Resources;
using Microsoft.Utilities;
using Microsoft.Foundation.Task;
using System.Threading;
using Microsoft.Projects.Resources.Reports;
using Microsoft.Projects.Project.Reports;

page 9014 "Job Resource Manager RC"
{
    Caption = 'Resource Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
#if not CLEAN24
            group(Control1900724808)
            {
                ObsoleteReason = 'Group removed for better alignment of Role Centers parts';
                ObsoleteState = Pending;
                ObsoleteTag = '24.0';
                ShowCaption = false;
                part(Control1904257908; "Resource Manager Activities")
                {
                    ApplicationArea = Jobs;
                }
                part("User Tasks Activities"; "User Tasks Activities")
                {
                    ApplicationArea = Suite;
                }
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = Jobs;
                }
            }
            group(Control1900724708)
            {
                ObsoleteReason = 'Group removed for better alignment of Role Centers parts';
                ObsoleteState = Pending;
                ObsoleteTag = '24.0';
                ShowCaption = false;
                part(Control19; "My Job Queue")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                }
                part(Control18; "Time Sheet Chart")
                {
                    ApplicationArea = Jobs;
                }
                part(Control22; "Report Inbox Part")
                {
                    ApplicationArea = Jobs;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = Jobs;
                }
            }
#else
            part(Control1904257908; "Resource Manager Activities")
            {
                ApplicationArea = Jobs;
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = Jobs;
            }
            part(Control19; "My Job Queue")
            {
                ApplicationArea = Jobs;
                Visible = false;
            }
            part(Control18; "Time Sheet Chart")
            {
                ApplicationArea = Jobs;
            }
            part(Control22; "Report Inbox Part")
            {
                ApplicationArea = Jobs;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Jobs;
            }
#endif
        }
    }

    actions
    {
        area(reporting)
        {
            action("Resource &Statistics")
            {
                ApplicationArea = Suite;
                Caption = 'Resource &Statistics';
                Image = "Report";
                RunObject = Report "Resource Statistics";
                ToolTip = 'View detailed information about usage and sales of each resource. The Resource Statistics window shows both the units of measure and the corresponding amounts.';
            }
            action("Resource &Utilization")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource &Utilization';
                Image = "Report";
                RunObject = Report "Resource Usage";
                ToolTip = 'View statistical information about the usage of each resource. The resource''s usage quantity is compared with its capacity and the remaining capacity (in the Balance field), according to this formula: Balance = Capacity - Usage (Qty.)';
            }
            action("Resource List")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource List';
                RunObject = Report "Resource List";
                ToolTip = 'View a list of unit prices for the resources. By default, a unit price is based on the price in the Resource Prices window. If there is no valid alternative price, then the unit price from the resource card is used. The report can be used by the company''s salespeople or sent to customers.';
            }
            action("Cost &Breakdown")
            {
                ApplicationArea = Jobs;
                Caption = 'Cost &Breakdown';
                RunObject = Report "Cost Breakdown";
                ToolTip = 'View the direct unit costs and the total direct costs for each resource. Only usage postings are considered in this report. Resource usage can be posted in the resource journal or the project journal.';
            }
            action("Completed Jobs")
            {
                Caption = 'Completed Projects';
                Image = "Report";
                RunObject = Report "Completed Jobs";
                ToolTip = 'View of list of projects that are fully processed.';
            }
            action("Job List")
            {
                Caption = 'Project List';
                Image = "Report";
                RunObject = Report "Job List";
                ToolTip = 'View a list of your outstanding projects. For each project, this report includes the customer number and name, and the budgeted price.';
            }
            action("Job Cost Transaction Detail")
            {
                Caption = 'Project Cost Transaction Detail';
                Image = "Report";
                RunObject = Report "Job Cost Transaction Detail";
                ToolTip = 'List the details of your project transactions. The report includes the project number and description followed by a list of the transactions that occurred in the period you specify.';
            }
        }
        area(embedding)
        {
            action(Resources)
            {
                ApplicationArea = Jobs;
                Caption = 'Resources';
                RunObject = Page "Resource List";
                ToolTip = 'Manage your resources'' project activities by setting up their costs and prices. The project-related prices, discounts, and cost factor rules are set up on the respective project card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a project, the specified prices and costs are recorded for the project.';
            }
            action(ResourcesPeople)
            {
                ApplicationArea = Jobs;
                Caption = 'People';
                RunObject = Page "Resource List";
                RunPageView = where(Type = filter(Person));
                ToolTip = 'View the list of people that can be assigned to projects.';
            }
            action(ResourcesMachines)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Machines';
                RunObject = Page "Resource List";
                RunPageView = where(Type = filter(Machine));
                ToolTip = 'View the list of machines that can be assigned to projects.';
            }
            action("Resource Groups")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Groups';
                RunObject = Page "Resource Groups";
                ToolTip = 'View all resource groups.';
            }
            action(ResourceJournals)
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Journals';
                RunObject = Page "Resource Jnl. Batches";
                RunPageView = where(Recurring = const(false));
                ToolTip = 'View all resource journals.';
            }
            action(RecurringResourceJournals)
            {
                ApplicationArea = Jobs;
                Caption = 'Recurring Resource Journals';
                RunObject = Page "Resource Jnl. Batches";
                RunPageView = where(Recurring = const(true));
                ToolTip = 'View all recurring resource journals.';
            }
            action(Jobs)
            {
                ApplicationArea = Jobs;
                Caption = 'Projects';
                Image = Job;
                RunObject = Page "Job List";
                ToolTip = 'Define a project activity by creating a project card with integrated project tasks and project planning lines, structured in two layers. The project task enables you to set up project planning lines and to post consumption to the project. The project planning lines specify the detailed use of resources, items, and various general ledger expenses.';
            }
            action("Time Sheets")
            {
                ApplicationArea = Jobs;
                Caption = 'Time Sheets';
                RunObject = Page "Time Sheet List";
                ToolTip = 'Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant project journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy project planning lines into time sheets.';
            }
            action("Page Time Sheet List Open")
            {
                ApplicationArea = Suite;
                Caption = 'Open';
                RunObject = Page "Time Sheet List";
                RunPageView = where("Open Exists" = const(true));
                ToolTip = 'Open the card for the selected record.';
            }
            action("Page Time Sheet List Submitted")
            {
                ApplicationArea = Suite;
                Caption = 'Submitted';
                RunObject = Page "Time Sheet List";
                RunPageView = where("Submitted Exists" = const(true));
                ToolTip = 'View submitted time sheets.';
            }
            action("Page Time Sheet List Rejected")
            {
                ApplicationArea = Suite;
                Caption = 'Rejected';
                RunObject = Page "Time Sheet List";
                RunPageView = where("Rejected Exists" = const(true));
                ToolTip = 'View rejected time sheets.';
            }
            action("Page Time Sheet List Approved")
            {
                ApplicationArea = Suite;
                Caption = 'Approved';
                RunObject = Page "Time Sheet List";
                RunPageView = where("Approved Exists" = const(true));
                ToolTip = 'View approved time sheets.';
            }
            action("Manager Time Sheets")
            {
                ApplicationArea = Jobs;
                Caption = 'Manager Time Sheets';
                RunObject = Page "Manager Time Sheet List";
                ToolTip = 'Open the list of your time sheets.';
            }
        }
        area(sections)
        {
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
#if not CLEAN23
                action("Resource Costs")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Costs';
                    RunPageView = where("Object Type" = const(Page), "Object ID" = const(203)); // "Resource Costs";
                    RunObject = Page "Role Center Page Dispatcher";
                    ToolTip = 'View or edit alternate costs for resources. Resource costs can apply to all resources, to resource groups or to individual resources. They can also be filtered so that they apply only to a specific work type code. For example, if an employee has a different hourly rate for overtime work, you can set up a resource cost for this work type.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                }
                action("Resource Prices")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Prices';
                    RunPageView = where("Object Type" = const(Page), "Object ID" = const(204)); // "Resource Prices";
                    RunObject = Page "Role Center Page Dispatcher";
                    ToolTip = 'View the prices of resources.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '17.0';
                }
#else
                action(PurchPriceLists)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Purchase Prices';
                    Image = ResourceCosts;
                    RunObject = Page "Purchase Job Price Lists";
                    ToolTip = 'View or change detailed information about costs for the resource.';
                }
                action(SalesPriceLists)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Sales Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Job Price Lists";
                    ToolTip = 'View or edit prices for the resource.';
                }
#endif
                action("Resource Service Zones")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Service Zones';
                    Image = Resource;
                    RunObject = Page "Resource Service Zones";
                    ToolTip = 'View the assignment of resources to service zones. When you allocate a resource to a service task that is to be performed at the customer site, you can select a resource that is located in the same service zone as the customer.';
                }
                action("Resource Locations")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Locations';
                    Image = Resource;
                    RunObject = Page "Resource Locations";
                    ToolTip = 'View where resources are located or assign resources to locations.';
                }
                action("Work Types")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Work Types';
                    RunObject = Page "Work Types";
                    ToolTip = 'View or edit the list of work types that are used with the registration of both the usage and sales of resources in project journals, resource journals, sales invoices, and so on. Work types indicate the various kinds of work that a resource is capable of carrying out, such as overtime or transportation.';
                }
                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Adjust R&esource Costs/Prices")
            {
                ApplicationArea = Jobs;
                Caption = 'Adjust R&esource Costs/Prices';
                Image = "Report";
                RunObject = Report "Adjust Resource Costs/Prices";
                ToolTip = 'Adjust one or more fields on the resource card. For example, you can change the direct unit cost by 10 percent on all resources from a specific resource group. The changes are processed immediately after the batch job is started. The fields on the resource card that are dependent on the adjusted field are also changed.';
            }
#if not CLEAN23
            action("Resource P&rice Changes")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource P&rice Changes';
                Image = ResourcePrice;
                RunPageView = where("Object Type" = const(Page), "Object ID" = const(493)); // "Resource Price Changes";
                RunObject = Page "Role Center Page Dispatcher";
                ToolTip = 'Edit or update alternate resource prices, by running either the Suggest Res. Price Chg. (Res.) batch job or the Suggest Res. Price Chg. (Price) batch job.';
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                ObsoleteTag = '17.0';
            }
            action("Resource Pr&ice Chg from Resource")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Pr&ice Chg from Resource';
                Image = "Report";
                RunPageView = where("Object Type" = const(Report), "Object ID" = const(1191)); // "Suggest Res. Price Chg. (Res.)";
                RunObject = Page "Role Center Page Dispatcher";
                ToolTip = 'Update the alternate prices in the Resource Prices window with the ones in the Resource Price Change s window.';
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                ObsoleteTag = '17.0';
            }
            action("Resource Pri&ce Chg from Prices")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Pri&ce Chg from Prices';
                Image = "Report";
                RunPageView = where("Object Type" = const(Report), "Object ID" = const(1192)); // "Suggest Res. Price Chg.(Price)";
                RunObject = Page "Role Center Page Dispatcher";
                ToolTip = 'Update the alternate prices in the Resource Prices window with the ones in the Resource Price Change s window.';
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                ObsoleteTag = '17.0';
            }
            action("I&mplement Resource Price Changes")
            {
                ApplicationArea = Jobs;
                Caption = 'I&mplement Resource Price Changes';
                Image = ImplementPriceChange;
                RunPageView = where("Object Type" = const(Report), "Object ID" = const(1193)); // "Implement Res. Price Change";
                RunObject = Page "Role Center Page Dispatcher";
                ToolTip = 'Update the alternate prices in the Resource Prices window with the ones in the Resource Price Changes window. Price change suggestions can be created with the Suggest Res. Price Chg.(Price) or the Suggest Res. Price Chg. (Res.) batch job. You can also modify the price change suggestions in the Resource Price Changes window before you implement them.';

                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                ObsoleteTag = '17.0';
            }
#else
            action("Pri&ce Worksheet")
            {
                ApplicationArea = Jobs;
                Caption = 'Price Worksheet';
                Image = ImplementPriceChange;
                RunObject = Page "Price Worksheet";
                ToolTip = 'Opens the page where you can add new price lines manually or copy them from the existing price lists or suggest new lines based on data in the product cards.';
            }
#endif
            action("Create Time Sheets")
            {
                ApplicationArea = Jobs;
                Caption = 'Create Time Sheets';
                Image = NewTimesheet;
                RunObject = Report "Create Time Sheets";
                ToolTip = 'Create new time sheets for resources.';
            }
        }
    }
}

