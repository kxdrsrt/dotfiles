# Xbox Series X — "Unplug the network cable" Error Fix Guide

## Symptoms

- "Unplug the network cable" error with no Ethernet cable connected
- Wi-Fi network selection completely blocked
- MAC address Clear freezes / restart button does nothing
- **Unusually long boot time** — Xbox logo displayed for an extended period before reaching the login screen (same on restart)

---

## Root Cause

The Xbox firmware detects a signal on the Ethernet port even when no cable is plugged in. This is usually caused by:

- **Dirty or bent Ethernet port pins** (common after disassembly)
- **Static charge** on the port
- **Corrupted network settings** in NVRAM
- **Damaged Ethernet controller** on the motherboard

> **Note on slow boot:** The boot firmware initialises all hardware sequentially, including the Ethernet controller. If the controller chip (RTL8111H) is faulty or a network module is disconnected, the firmware waits for a hardware response that never comes and must time out before continuing — this is what causes the long delay at the Xbox logo screen. **Slow boot + phantom Ethernet error together is a strong combined indicator of RTL8111H chip failure** (see final section).

---

## Step-by-Step Fix Guide

### Step 1 — Power Cycle (Hard Reset)

1. Hold the **Xbox button** for 10 seconds to fully power off
2. **Unplug the power brick** from the wall
3. Press the power button **a few times while unplugged** to drain any residual power from capacitors
4. Wait **2 full minutes**, then plug back in and power on

---

### Step 2 — Check the Ethernet Port Physically

Since you just reassembled it:

- Shine a light into the **Ethernet port** on the back
- Look for **bent pins**, **debris**, **solder bridges**, or **foam/plastic accidentally left inside**
- The Ethernet port has **8 small copper pins** — if any are bent and touching each other or touching the metal housing, the Xbox reads that closed circuit as a plugged-in cable
- Use a **wooden toothpick or plastic sewing needle** to gently bend any misaligned pins back into their parallel slots — avoid metal tools
- Also check that the **rear metal I/O shield is not bent inward**, accidentally pressing against the inside of the Ethernet port housing

---

### Step 3 — Clear Network Settings

1. Press the **Xbox button** → **Profile & system** → **Settings**
2. Go to **General** → **Network settings**
3. Select **Advanced settings** → **Alternate MAC address**
4. Choose **Clear** → Restart when prompted

> **Known issue — Restart button does nothing after pressing Clear:**
> If the console freezes and refuses to restart after pressing Clear, this is actually a **strong hardware clue** — the OS is hanging while trying to communicate with the networking chip. This points to a loose Wi-Fi/Bluetooth module or ribbon cable rather than a pure software glitch. The Clear action is saved before the restart prompt appears, so a manual restart still applies the change. Try one of these workarounds:
>
> - **Option A:** Press **Clear**, then immediately hold the **Xbox button on the console** for 10 seconds to force power off. Unplug power for 30 seconds, then boot back up.
> - **Option B:** Press **Clear**, then when the frozen restart dialog appears, press the **Xbox button on your controller** and navigate to **Profile & system** → **Restart console** from the guide menu.
> - **Option C:** If the UI is fully unresponsive, hold the **Xbox button on the console** for 10 seconds to shut down, then hold **Pair + Eject** and tap the **Xbox button** once to enter the **Startup Troubleshooter**.

---

### Step 4 — Factory Reset Network Only

1. **Settings** → **System** → **Console info**
2. Select **Reset console**
3. Choose **"Reset and keep my games & apps"** — this resets settings including network without deleting data

---

### Step 4b — Disable Instant-On (Energy-Saving Power Mode)

Instant-On keeps networking hardware in a low-power background state, which can preserve a stuck/"ghost" connection state across reboots. Switching to full shutdown forces a clean cold boot of the network stack each time.

1. **Profile & system** → **Settings** → **General** → **Power options** (Power mode & startup)
2. Set **Power mode** to **Energy-saving**
3. Fully power the console off and on once after changing this

---

### Step 5 — Offline System Update (if UI is inaccessible)

If you can't navigate settings due to the error blocking you:

1. On a PC, download the **Xbox Offline System Update** from [support.xbox.com](https://support.xbox.com)
2. Format a USB drive as **NTFS**
3. Copy the update files to the root of the USB
4. With the Xbox **off**, hold the **Pair button + Eject button**, then press the **Xbox button**
5. This boots into the **Xbox Startup Troubleshooter**
6. Select **Reset this Xbox** from there

---

### Step 6 — Inspect the Wi-Fi/Bluetooth Board and Internal Connections

The Xbox Series X uses a modular board system. If the Wi-Fi/Bluetooth card is even slightly misseated, the motherboard loses communication with the wireless chip and defaults to assuming only the Ethernet port exists — triggering this exact error loop.

**Wi-Fi/Bluetooth board (most likely cause of the freeze):**

- Unscrew the Wi-Fi card completely from the inner metal frame
- Shine a flashlight into the board-to-board slot on the motherboard — check for trapped dust or debris
- Firmly push the card back in ensuring it is **100% flush and level** before re-screwing — even a slight angle causes the communication failure

**Ribbon cables:**

- Flip open the **tiny plastic latch** on each ribbon cable connector
- Pull the cable out and inspect the **gold/silver contact fingers** — check for folded-over or dirty contacts
- Re-insert perfectly straight and lock the latch down firmly

**ESD and grounding:**

- Ensure no **conductive material, stray metallic debris, or thermal pad offcut** is touching the circuit traces near the Ethernet controller chip (located near the rear of the board)
- Confirm the motherboard is sitting correctly on all its standoffs

**Cold solder joints:**

- If you did any soldering, check for cold joints on the Ethernet port pins
- The rear IO board (if your model has one as a separate daughterboard) may not be fully reseated

---

## Should You Try Connecting via Ethernet?

**Yes — try it.** Here's how and why:

1. Plug a working Ethernet cable from your **router** into the Xbox
2. Let the console register the wired connection and go to **Network settings → Test network connection**
3. Let it get fully online over wired
4. **Properly shut the Xbox down**, then unplug the Ethernet cable
5. Boot back up and check if wireless is now selectable

If this clears the error, it confirms a **firmware/OS cache glitch**, not a hardware fault. If the error returns the moment you unplug the cable, you are almost certainly dealing with **bent pins inside the physical Ethernet port** (see Step 2).

## Quick Diagnostic — Wireless Controller Sync Test

Before opening the console again, do this test:

- Try to **sync a wireless controller** using the Pair button on the console
  - **Controller won't sync wirelessly at all** → The Wi-Fi/Bluetooth module is completely disconnected or dead — that single card handles both Wi-Fi and wireless controller communication. Open the console and reseat it (see Step 6).
  - **Controller works fine wirelessly** → The module has power but the data lines for networking are loose, or the Ethernet port pins are shorted. Focus on Steps 2 and 6.

---

## Summary Table

| Symptom                                        | Likely Cause                                                  | Fix                                          |
| ---------------------------------------------- | ------------------------------------------------------------- | -------------------------------------------- |
| Error clears after plugging in real Ethernet   | OS/firmware cache glitch                                      | Ethernet trick + network reset               |
| Error appeared only after reassembly           | Bent port pin or unseated IO board                            | Step 2 + Step 6                              |
| MAC address Clear freezes / won't restart      | Wi-Fi module communication failure                            | Reseat Wi-Fi card and ribbon cables (Step 6) |
| Wireless controller also won't sync            | Wi-Fi/Bluetooth module disconnected                           | Reseat Wi-Fi/BT board (Step 6)               |
| Error persists after full reset and reassembly | Ethernet controller IC fault                                  | Motherboard repair/replacement               |
| **Slow boot + phantom Ethernet error**         | **RTL8111H chip failure (hardware timeout during boot init)** | **Micro-solder RTL8111H chip replacement**   |
| USB troubleshooter also fails                  | Deeper firmware corruption                                    | Microsoft repair service                     |

---

## Confirmed Hardware Culprit — Ethernet Chip (RTL8111H)

> **Source:** TronicsFix repair forum — a professional repair tech (Calvin) and a user case (Brick) describing this exact symptom.

The most likely root cause when software fixes fail is the **Realtek RTL8111H Ethernet controller chip** on the motherboard. **When this chip fails, the Xbox detects a LAN connection even with no Ethernet cable plugged in** — producing exactly the "unplug the network cable" error and blocking Wi-Fi.

Key takeaways from the repair community:

- **Slow boot time is a direct secondary symptom of this chip failure.** During boot, the firmware tries to initialise the RTL8111H. When it is failing, the chip does not respond within normal time, causing the firmware to sit at the Xbox logo waiting for a hardware timeout before proceeding. If you are seeing both slow boot and the phantom Ethernet error, this is the most likely diagnosis.
- **Cleaning the port, factory resetting, and swapping the Wi-Fi/network card do NOT fix it** if the RTL8111H is the fault — these were all tried by an affected user with no success.
- Repairing it requires **micro-soldering skills** to replace the RTL8111H chip.
- **A Southbridge / daughterboard swap will NOT work on newer Xbox Series X units.** The flash chip on the Southbridge now stores paired console-specific data that must be transferred to any replacement board — this is no easier than replacing the Ethernet chip itself.
- If you are not comfortable with micro-soldering, this is a job for a **professional board-repair service** or Microsoft repair.

### Why Does the RTL8111H Fail?

#### Most Likely — Pre-existing Thermal Degradation (Even After a Professional Clean)

The RTL8111H is a **BGA package** — its solder balls are hidden completely underneath the chip, invisible from the outside. Years of the console heating up and cooling down causes **thermal cycling stress** that gradually weakens these solder joints. By the time the console is opened for cleaning, the chip may already be on the edge of failure. Physical handling during disassembly — even done professionally — can flex the PCB just enough to complete a hairline crack that was already forming.

**The cleaning didn't cause the failure. It revealed it.** The chip was already failing; disassembly simply triggered it to manifest at that moment.

#### Cleaning-Related Causes

| Cause                             | How it happens                                                                                                                               |
| --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **ESD (electrostatic discharge)** | A static discharge you don't feel (as low as 10V) can silently damage BGA chips. Requires an anti-static mat and wrist strap during handling |
| **PCB flex**                      | Laying the board flat, pressing on it, or handling it by the edges bows the PCB slightly — enough to crack BGA solder joints                 |
| **Compressed air on chips**       | The propellant gets extremely cold (~−40°C), causing sudden thermal shock on solder joints                                                   |
| **Solvent contact**               | IPA or other cleaning solvent under the chip that wasn't fully evaporated before reassembly can cause shorts or corrosion                    |
| **Thermal pad displacement**      | A thermal pad shifting onto circuit traces near the Ethernet controller during repasting                                                     |

---

**Reference video:** [Xbox Series X: Update loop, No LAN — Ethernet chip replacement](https://www.youtube.com/watch?v=gQZuZ19eEAo)

## Sources

- [TronicsFix Forum — Xbox Series X will not connect to the internet (RTL8111H diagnosis)](https://www.tronicsfixforum.com/t/xbox-series-x-will-not-connect-to-the-internet/13925)
- [Windows Report — Xbox Series X Keeps Disconnecting From Ethernet (Instant-On & reset steps)](https://windowsreport.com/ethernet-keeps-disconnecting-xbox/)
- Reddit r/XboxSupport — "Series X Thinks Ethernet Cable is Plugged In When It's Not" (community reports of the same symptom)
