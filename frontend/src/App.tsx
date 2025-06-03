import React from "react";
import { WSClient } from "./lib/ws";
import { useControls } from "./hooks/useControls";

import VideoFeed from "./components/VideoFeed";
import ControlsOverlay from "./components/ControlsOverlay";
import { SettingsDialog } from "./components/settings-dialog";

const ws = new WSClient("ws://localhost:8000/ws");

export default function App() {
  const { axes, mode, setMode, gamepadConnected, headlessMode, toggleHeadlessMode } = useControls(ws);

  // Global escape key handler for TrackPoint mode
  React.useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === "Escape" && mode === "mouse") {
        setMode("inc"); // Switch back to keyboard mode
      }
    };

    window.addEventListener("keydown", handleEscape);
    return () => window.removeEventListener("keydown", handleEscape);
  }, [mode, setMode]);

  const handleTakeoff = () => {
    ws.send({ type: "takeoff" });
  };

  const handleLand = () => {
    ws.send({ type: "land" });
  };

  return (
    <div className="relative min-h-screen bg-black text-white">
      {/* Settings button in top-right corner */}
      <div className="absolute top-4 right-4 z-30">
        <SettingsDialog 
          mode={mode}
          setMode={setMode}
          gamepadConnected={gamepadConnected}
          headlessMode={headlessMode}
          toggleHeadlessMode={toggleHeadlessMode}
        />
      </div>
      <VideoFeed />
      <ControlsOverlay axes={axes} onTakeoff={handleTakeoff} onLand={handleLand} />
    </div>
  );
}
