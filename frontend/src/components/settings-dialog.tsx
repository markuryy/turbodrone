import * as React from "react"
import {
  Gamepad2,
  Settings,
} from "lucide-react"
import type { ControlMode } from "../hooks/useControls"


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
    { name: "UI", icon: Settings },
  ],
}

interface SettingsDialogProps {
  mode: ControlMode;
  setMode: (m: ControlMode) => void;
  gamepadConnected: boolean;
  headlessMode: boolean;
  toggleHeadlessMode: () => void;
  showStickVisualizers: boolean;
  toggleStickVisualizers: () => void;
}

export function SettingsDialog({ 
  mode, 
  setMode, 
  gamepadConnected, 
  headlessMode, 
  toggleHeadlessMode,
  showStickVisualizers,
  toggleStickVisualizers
}: SettingsDialogProps) {
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
            <div className="flex flex-1 flex-col gap-4 overflow-y-auto p-4">
              <div className="text-gray-300">
                <h3 className="text-lg font-semibold mb-4 pt-4">{activeSection} Settings</h3>
                <div className="space-y-4">
                  {activeSection === "Controls" && (
                    <div className="space-y-4">
                      <p className="text-sm text-gray-400">Configure control input method and flight mode</p>
                      
                      {/* Control Mode Selection */}
                      <div className="bg-gray-800 p-4 rounded-lg space-y-4">
                        <h4 className="text-sm font-medium text-gray-200">Input Method</h4>
                        <div className="flex flex-wrap gap-3">
                          <button
                            onClick={() => setMode("inc")}
                            className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                              mode === "inc" ? "bg-sky-600 text-white" : "bg-gray-600 hover:bg-gray-500 text-gray-200"
                            }`}
                          >
                            Keyboard
                          </button>
                          <button
                            onClick={() => {
                              if (gamepadConnected) setMode("abs");
                            }}
                            disabled={!gamepadConnected}
                            className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                              mode === "abs"
                                ? "bg-green-600 text-white"
                                : gamepadConnected
                                  ? "bg-gray-600 hover:bg-gray-500 text-gray-200"
                                  : "bg-gray-700 cursor-not-allowed opacity-60 text-gray-400"
                            }`}
                          >
                            Gamepad
                          </button>
                          <button
                            onClick={() => {
                              document.body.requestPointerLock();
                              setMode("mouse");
                              setOpen(false);
                            }}
                            className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                              mode === "mouse"
                                ? "bg-red-600 text-white"
                                : "bg-gray-600 hover:bg-gray-500 text-gray-200"
                            }`}
                          >
                            TrackPoint
                          </button>
                        </div>
                      </div>

                      {/* Headless Mode Toggle */}
                      <div className="bg-gray-800 p-4 rounded-lg space-y-3">
                        <h4 className="text-sm font-medium text-gray-200">Flight Mode</h4>
                        <div className="flex items-center gap-3">
                          <button
                            onClick={toggleHeadlessMode}
                            className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                              headlessMode ? "bg-purple-600 text-white" : "bg-gray-600 hover:bg-gray-500 text-gray-200"
                            }`}
                          >
                            {headlessMode ? "Headless: ON" : "Headless: OFF"}
                          </button>
                          <div className="text-xs text-gray-400 flex items-center gap-1">
                            <span title="Controls relative to pilot, not drone orientation">ℹ️</span>
                            <span>Controls relative to pilot orientation</span>
                          </div>
                        </div>
                      </div>

                      {/* Status Display */}
                      <div className="bg-gray-800 p-4 rounded-lg space-y-2">
                        <h4 className="text-sm font-medium text-gray-200">Status</h4>
                        <div className="text-sm text-gray-300">
                          <div className="flex justify-between items-center">
                            <span>Current Input:</span>
                            <span className="font-semibold text-gray-100">
                              {mode === "inc" ? "Keyboard"
                                : mode === "abs" ? "Gamepad"
                                : "TrackPoint"}
                            </span>
                          </div>
                          <div className="flex justify-between items-center">
                            <span>Gamepad:</span>
                            <span className={`font-semibold ${
                              gamepadConnected ? "text-green-400" : "text-red-400"
                            }`}>
                              {gamepadConnected ? "Connected" : "Disconnected"}
                            </span>
                          </div>
                          {mode === "mouse" && (
                            <div className="text-xs text-gray-400 mt-2">
                              Press Esc to release mouse lock
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  )}
                  {activeSection === "UI" && (
                    <div className="space-y-4">
                      <p className="text-sm text-gray-400">Configure user interface display options</p>
                      
                      {/* Stick Visualizers Toggle */}
                      <div className="bg-gray-800 p-4 rounded-lg space-y-3">
                        <h4 className="text-sm font-medium text-gray-200">HUD Elements</h4>
                        <div className="flex items-center gap-3">
                          <button
                            onClick={toggleStickVisualizers}
                            className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                              showStickVisualizers ? "bg-blue-600 text-white" : "bg-gray-600 hover:bg-gray-500 text-gray-200"
                            }`}
                          >
                            {showStickVisualizers ? "Stick Visualizers: ON" : "Stick Visualizers: OFF"}
                          </button>
                          <div className="text-xs text-gray-400 flex items-center gap-1">
                            <span title="Show/hide stick position indicators in the HUD">ℹ️</span>
                            <span>Toggle stick position indicators</span>
                          </div>
                        </div>
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
