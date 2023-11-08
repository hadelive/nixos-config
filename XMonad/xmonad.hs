import Control.Monad (forM_)
import qualified Data.Map as M
import GHC.IO.Handle (Handle)
import System.Exit (exitSuccess)
import qualified XMonad as X
import qualified XMonad.Actions.SpawnOn as X
import qualified XMonad.Hooks.DynamicLog as X
import qualified XMonad.Hooks.ManageDocks as X
import qualified XMonad.Layout.LayoutModifier as X
import qualified XMonad.StackSet as XS
import qualified XMonad.Util.Run as X
import qualified XMonad.Util.SpawnOnce as X

-- The number of monitors
numOfMonitors :: Int
numOfMonitors = 3

-- Our custom XMonad configurations
-- The remaining defaults are defined in xmonad/XMonad/Config.hs
xmonad :: X.XConfig (X.ModifiedLayout X.AvoidStruts (X.Choose X.Tall X.Full))
xmonad = X.def
  { X.modMask = X.mod4Mask -- Windows / Super
  , X.terminal = "alacritty"
  , X.workspaces = ["dev", "www", "comm"] ++ map show [4..9]
  , X.layoutHook = X.avoidStruts ((X.Tall 1 (3 / 100) (1 / 2)) X.||| X.Full)
  , X.borderWidth = 2

  , X.keys = \X.XConfig{X.modMask = modm, X.terminal = term, X.workspaces = ws} -> M.fromList $
    [ -- Launch terminal
      ((modm X..|. X.shiftMask, X.xK_Return), X.spawn term)
      -- Launch dmenu
    , ((modm, X.xK_p), X.spawn "dmenu_run")
      -- Close focused window
    , ((modm X..|. X.shiftMask, X.xK_c), X.kill)
      -- Rotate through the available layouts
    , ((modm, X.xK_space), X.sendMessage X.NextLayout)
      -- Move focus to the next window
    , ((modm, X.xK_Tab), X.windows XS.focusDown)
      -- Swap the focused window and the master window
    , ((modm, X.xK_Return), X.windows XS.swapMaster)
      -- Shrink the master area
    , ((modm, X.xK_Left), X.sendMessage X.Shrink)
      -- Expand the master area
    , ((modm, X.xK_Right), X.sendMessage X.Expand)
      -- Lock screen
    , ((modm, X.xK_l), X.spawn "xautolock -locknow")
      -- Restart xmonad
    , ((modm, X.xK_q), X.spawn "xmonad --recompile; xmonad --restart")
      -- Quit xmonad
    , ((modm X..|. X.shiftMask, X.xK_q), X.io exitSuccess)
    ]
    ++
    -- Switch to a workspace & throw window to another workspace
    [ ((m X..|. modm, k), X.windows (f i))
      | (i, k) <- zip ws [X.xK_1 .. X.xK_9],
        (m, f) <- [(0, XS.greedyView), (X.shiftMask, XS.shift)]
    ]

  , X.manageHook = X.manageSpawn
  , X.startupHook = do
    X.spawnOnOnce "dev" "alacritty"
    X.spawnOnOnce "www" "google-chrome-stable"
    X.spawnOnOnce "comm" "slack"
    X.spawnOnOnce "comm" "telegram-desktop"
  }

-- Log hook with XMobar
xmobar :: [Handle] -> X.X ()
xmobar pipes = X.dynamicLogWithPP $
  X.xmobarPP
    { X.ppOutput = forM_ pipes . flip X.hPutStrLn
    , X.ppTitle = X.xmobarColor "#22CCDD" "" . X.shorten 100
    , X.ppCurrent = X.xmobarColor "#CEFFAC" ""
    , X.ppSep = "      "
    }

-- Entry point to XMonad
main :: IO ()
main = do
  -- Spawn an XMobar pipe at each screen
  xmobarPipes <- mapM
    (X.spawnPipe . ("xmobar ~/.config/xmobar/xmobarrc -x " <>) . show)
    [0 .. numOfMonitors - 1]

  -- Initiate XMonad with XMobar
  X.xmonad (X.docks xmonad { X.logHook = xmobar xmobarPipes })
