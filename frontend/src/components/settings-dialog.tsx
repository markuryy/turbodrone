import * as React from "react"
import {
  Gamepad2,
  Settings,
  Video,
  Wifi,
  Plane,
} from "lucide-react"

import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarProvider,
} from "@/components/ui/sidebar"

const data = {
  nav: [
    { name: "Controls", icon: Gamepad2 },
    { name: "Connection", icon: Wifi },
    { name: "Video", icon: Video },
    { name: "Flight", icon: Plane },
    { name: "Advanced", icon: Settings },
  ],
}

export function SettingsDialog() {
  const [open, setOpen] = React.useState(false)
  const [activeSection, setActiveSection] = React.useState("Controls")

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button size="sm" variant="outline" className="bg-gray-900/70 backdrop-blur-md border-gray-700/80 text-white hover:bg-gray-800/70">
          <Settings className="h-4 w-4" />
        </Button>
      </DialogTrigger>
      <DialogContent className="overflow-hidden p-0 md:max-h-[500px] md:max-w-[700px] lg:max-w-[800px] bg-gray-900 border-gray-700">
        <DialogTitle className="sr-only">Settings</DialogTitle>
        <DialogDescription className="sr-only">
          Customize your settings here.
        </DialogDescription>
        <SidebarProvider className="items-start dark">
          <Sidebar collapsible="none" className="hidden md:flex bg-gray-800 border-r border-gray-700">
            <SidebarContent>
              <SidebarGroup>
                <SidebarGroupContent>
                  <SidebarMenu>
                    {data.nav.map((item) => (
                      <SidebarMenuItem key={item.name}>
                        <SidebarMenuButton
                          isActive={item.name === activeSection}
                          onClick={() => setActiveSection(item.name)}
                        >
                          <item.icon />
                          <span>{item.name}</span>
                        </SidebarMenuButton>
                      </SidebarMenuItem>
                    ))}
                  </SidebarMenu>
                </SidebarGroupContent>
              </SidebarGroup>
            </SidebarContent>
          </Sidebar>
          <main className="flex h-[480px] flex-1 flex-col overflow-hidden bg-gray-900">
            <header className="flex h-16 shrink-0 items-center gap-2 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12 bg-gray-800 border-b border-gray-700">
              <div className="flex items-center gap-2 px-4">
                <Breadcrumb className="text-gray-300">
                  <BreadcrumbList>
                    <BreadcrumbItem className="hidden md:block">
                      <BreadcrumbLink href="#">Settings</BreadcrumbLink>
                    </BreadcrumbItem>
                    <BreadcrumbSeparator className="hidden md:block" />
                    <BreadcrumbItem>
                      <BreadcrumbPage>{activeSection}</BreadcrumbPage>
                    </BreadcrumbItem>
                  </BreadcrumbList>
                </Breadcrumb>
              </div>
            </header>
            <div className="flex flex-1 flex-col gap-4 overflow-y-auto p-4 pt-0">
              <div className="text-gray-300">
                <h3 className="text-lg font-semibold mb-4">{activeSection} Settings</h3>
                <div className="space-y-4">
                  {activeSection === "Controls" && (
                    <div className="space-y-2">
                      <p className="text-sm text-gray-400">Configure control sensitivity and key bindings</p>
                      <div className="bg-gray-800 p-4 rounded-lg">
                        <p className="text-sm">Control settings will be implemented here</p>
                      </div>
                    </div>
                  )}
                  {activeSection === "Connection" && (
                    <div className="space-y-2">
                      <p className="text-sm text-gray-400">Configure WebSocket connection settings</p>
                      <div className="bg-gray-800 p-4 rounded-lg">
                        <p className="text-sm">Connection settings will be implemented here</p>
                      </div>
                    </div>
                  )}
                  {activeSection === "Video" && (
                    <div className="space-y-2">
                      <p className="text-sm text-gray-400">Configure video feed settings</p>
                      <div className="bg-gray-800 p-4 rounded-lg">
                        <p className="text-sm">Video settings will be implemented here</p>
                      </div>
                    </div>
                  )}
                  {activeSection === "Flight" && (
                    <div className="space-y-2">
                      <p className="text-sm text-gray-400">Configure flight safety and parameters</p>
                      <div className="bg-gray-800 p-4 rounded-lg">
                        <p className="text-sm">Flight settings will be implemented here</p>
                      </div>
                    </div>
                  )}
                  {activeSection === "Advanced" && (
                    <div className="space-y-2">
                      <p className="text-sm text-gray-400">Advanced system settings</p>
                      <div className="bg-gray-800 p-4 rounded-lg">
                        <p className="text-sm">Advanced settings will be implemented here</p>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </main>
        </SidebarProvider>
      </DialogContent>
    </Dialog>
  )
}
