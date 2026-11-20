// Variable declarations to track player preparation and choices
VAR has_sharpened_sword = false
VAR has_healing_potion = false
VAR knows_boss_weakness = false
VAR fatigue = 0

-> intro

=== intro ===
#bg:Mine
You are **Octavias**, a seasoned Mercenary hired by the village of Oakhaven to clear out the Ironclad Wyvern nesting in the abandoned mine. You already have your trusted broadsword, a sturdy leather cuirass, and a single silver coin. 

The mine entrance looms ahead, dark and cold, with the distant rumble of the beast echoing from the depths. Before stepping inside, you have a brief moment to prepare at the outskirts.

* [Visit the wandering blacksmith at the camp.]
    -> blacksmith
* [Search the nearby ruins for supplies.]
    -> ruins
* [Speak with the injured miner resting by the road.]
    -> miner
* [Head straight into the mine while you have the element of surprise.]
    ~ fatigue += 1
    -> mine_entrance

=== blacksmith ===
#bg:Blacksmith
The blacksmith eyes your blade and offers to sharpen it on his whetstone—or reinforce your armor—for your single silver coin.

* [Pay him to sharpen your broadsword.]
    ~ has_sharpened_sword = true
    The edge gleams with a razor-sharp finish. It will bite deep into heavy scales.
    -> mine_entrance
* [Keep your coin and head into the mine.]
    -> mine_entrance

=== ruins ===
#bg:Ruins
You scour the overgrown ruins of the old mining office. Behind a collapsed bookshelf, you find a dusty wooden crate.

* [Pry the crate open with your sword.]
    ~ fatigue += 1
    ~ has_healing_potion = true
    You strain your shoulder forcing the lid off, tiring yourself out slightly, but inside lies a crimson **Healing Potion**.
    -> mine_entrance
* [Leave it alone and conserve your energy.]
    -> mine_entrance

=== miner ===
The miner bandages his scorched arm. "Listen closely," he rasps. "That wyvern's chest scales are impenetrable. Don't aim for its heart. Wait for it to rear back to breathe fire—its throat glows bright orange right before it strikes. That's the only soft spot."

* [Thank him and head toward the mine.]
    ~ knows_boss_weakness = true
    -> mine_entrance

=== mine_entrance ===
# bg:Wyvern
You step into the cavernous shaft of the mine. Torchlight flickers against damp stone. As you reach the central chamber, a massive shadow detaches itself from the ceiling. 

The **Ironclad Wyvern** lands with a deafening crash, blocking the exit. Smoke curls from its nostrils as it locks yellow eyes onto you.

// Evaluate player's state before the battle starts
{ fatigue > 0:
    Your muscles already ache from your earlier exertion.
}

-> boss_fight

=== boss_fight ===
The wyvern lunges forward, snapping its massive jaws before rearing back on its hind legs. A deep, fiery glow begins to build in its chest and rise up its neck. How do you engage the beast?

* [Charge head-on and strike at its chest scales.]
    { has_sharpened_sword:
        Your newly sharpened blade sparks violently against the wyvern's chest, leaving a deep gouge, though it doesn't pierce all the way through. The beast roars in pain and swipes you with its tail!
        -> take_hit
    - else:
        Your dull blade bounces harmlessly off the iron-hard scales! The wyvern slams its tail into your ribs, sending you flying across the cavern.
        -> bad_hit
    }
* { knows_boss_weakness } [Wait for the glow to reach its throat, then thrust your blade upward.]
    You hold your nerve as the heat intensifies. Just as the wyvern opens its jaws to unleash a torrent of flame, you step inside its reach and drive your sword straight into its glowing, unarmored throat!
    { has_sharpened_sword:
        The razor-sharp steel sinks to the hilt. The wyvern's fire chokes out in a hiss of steam as the beast collapses, defeated in a single decisive strike!
        -> victory
    - else:
        Your blade pierces the soft flesh, disrupting the fire breath, though the dull edge struggles to cut deep. The wounded wyvern thrashes wildly, clipping you with a heavy claw!
        -> take_hit
    }
* [Keep your distance and try to outmaneuver it.]
    { fatigue > 0:
        You try to dodge its sweeping tail, but your tired legs fail you. The wyvern's heavy limb catches you squarely in the chest!
        -> bad_hit
    - else:
        Fresh and agile, you vault over its sweeping tail and slash at its flank, drawing dark blood. The wyvern whips around, snarling in fury.
        -> second_phase
    }

=== take_hit ===
You hit the stone floor hard, blood trickling from your lip. The wyvern stalks closer, preparing to finish you off.

* { has_healing_potion } [Drink the Healing Potion and scramble back up.]
    ~ has_healing_potion = false
    You uncork the vial and down the bitter liquid. Warmth floods your veins, knitting your bruised ribs back together just as the wyvern lunges!
    -> second_phase
* [Raise your sword to block its incoming jaws.]
    You brace for impact, but the beast's strength is overwhelming. Without a way to recover your strength, your guard shatters.
    -> defeat

=== bad_hit ===
The impact cracks your armor and knocks the wind from your lungs. Vision blurring, you struggle to lift your weapon.

* { has_healing_potion } [Desperately drink your Healing Potion.]
    ~ has_healing_potion = false
    You manage to swallow the potion right before the wyvern pins you down. The sudden surge of vitality gives you the strength to roll clear of its jaws!
    -> second_phase
* [Try to crawl away.]
    The cavern exit is blocked. The wyvern steps forward, engulfing the tunnel in roaring flame.
    -> defeat

=== second_phase ===
Wounded and enraged, the wyvern abandons caution and charges blindly toward you, jaws wide open.

* { has_sharpened_sword || knows_boss_weakness } [Plant your feet and deliver a final counter-strike.]
    Using every ounce of skill you possess, you sidestep the beast's reckless charge and drive your steel deep into its exposed neck. With a final, earth-shaking thud, the Ironclad Wyvern falls dead.
    -> victory
* [Attempt a desperate, unguided swing.]
    Without a sharp edge or knowledge of its weak point, your strike glances off its skull. The wyvern's momentum crushes you against the cavern wall.
    -> defeat

=== victory ===
**VICTORY!** Silence returns to the Oakhaven mine. You wipe the soot from your brow, sheathing your weapon beside the fallen wyvern. Your preparation paid off—the village is safe, and your legend grows.
-> END

=== defeat ===
**DEFEAT!** Darkness closes in as the wyvern's roar echoes through the cavern. Without the right preparation, even a seasoned mercenary is no match for the beasts of the deep.
-> END