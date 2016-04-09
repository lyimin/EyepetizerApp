// LoadingMessagesHandler.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 apegroup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

class LoadingMessagesHandler {
    private var messages: [String]!

    init(languageType: LanguageType) {
        if languageType == .English {
            messages = englishFunnyMessages()
        }
    }
    
    init(messages: [String]) {
        self.messages = messages
    }

    func randomMessage() -> String {
        if messages.count == 0 {
            return ""
        }

        let randomIndex = Int(arc4random_uniform(UInt32(messages.count)))
        let message = messages[randomIndex]
        messages.removeAtIndex(randomIndex)

        return message
    }
    
    func firstMessage() -> String {
        if messages.count == 0 {
            return ""
        }
        
        let message = messages[0]
        messages.removeAtIndex(0)
        
        return message
    }
    
    func lastMessage() -> String {
        if messages.count == 0 {
            return ""
        }
        
        let message = messages[messages.count]
        messages.removeAtIndex(messages.count)
        
        return message
    }

    private func englishFunnyMessages() -> [String] {
        return Array(arrayLiteral: "Reticulating Splines...","Gathering Goblins...","Lifting Weights...","Pushing Pixels...","Formulating Plan...","Taking Break...","Herding Ducks...","Feeding Developers...","Fishing for Change...","Searching for Dancers...","Waking Up Gnomes...","Playing Chess...","Building Igloos...","Converting Celsius...","Scanning Power Level...","Delivering Presents...","Finding Dragon Balls...","Firing Lasers...","Party Rocking...","Walking up to the club...","Righting wrongs...","Building Lego...","Assembling Avengers...","Turning Down for What...","Reaching 88mph...","Pondering Existence...","Battling Robots...","Smashing Pots...","Stomping Goombas...","Doing Donuts...","Entering Danger Zone...","Talking to Mom...","Chasing Squirrels...","Doing Macarena...","Dropping Bass...","Removing Biebers...","Performing Magic...","Autotuning Kanye...","Waxing Legs...","Invading Space...","Levelling Up...","Generating Map...","Feeding Intern...","Piloting Tardis...","Destroying Deathstar...","Typing Letters...","Making Code...","Running Marathon...","Shooting Pucks...","Kicking Field Goals...","Fighting Bad Guys...","Driving Batmobile...","Warming Up Kryptonite...","Popping Popcorn...","Creating Hashes...","Spawning Boss...","Evaluating Life Choices...","Eating Ramen...","Re-heating Leftovers...","Petting Kittens...","Walking Puppies...","Catching Z’s...","Jumping Rope...","Declaring Variables...","Yessing Doge...","Recycling Memes...","Tipping Fedora...","Walking Runway...","Counting to Ten...","Booting Native Client...","Launching App...","Drawing Icons...","Reading Instructions...","Finding Screws...","Completing Puzzles...","Generating Volume Slider...","Brightening Orange...","Ordering Pizza...","You Look Good Today...","Clearing Screen...","Stirring Pot...","Mashing Potatoes...","Banishing Evil...","Taking Selfies...","Accelerating Disks...","Benching Network...","Rocking Out...","Grinding Mage...","Studying Calculus...","Playing N64...","Racing GoKarts...","Defeating Creepers...","Blowing Game Cartridge...","Choosing Pikachu...","Postponing Half Life 3...","Rushing Zergs...","Rescuing Hostages...","Typing Konami Code...","Building Snowman...","Letting it Snow...","Burning HDMI Cords...","Applying Filters...","Taking Screenshot...","Shaving Mustache...","Growing Beard...","Baking Muffins...","Iterating Javascript...","Attracting Venture Capital...","Disrupting Industry...","Tweeting Hashtags...","Encrypting Lines...","Obfuscating C...","Enhancing License Plate...","Running Diagnostic...","Warming Hyperdrive...","Calibrating Positions...","Calculating Percentages...","Revoking Licenses...","Shedding Core...","Dampening Gravity...","Increasing Power...","Checking Sensors...","Indexing RSS...","Programming PCI...","Determining USB Position...","Connecting to Bus...","Inverting Ports...","Bypassing Capacitor...","Reversing Bandwidth Throttle...","Testing AI...","Virtualizing Microchip...","Emulating Playstation...","Synthesizing Drivers...","Structuring Chlorophyll...","Watering Plants...","Ingesting Caffeine...","Chugging Redbull...","Parsing System...","Navigating Arrays...","Searching Google...","Overflowing Stack...","Compiling Binaries...","Answering Emails...","Migrating CSS...","Backing Up Primaries...","Rendering Dialogs...","Reading RSS...","Compressing Data...","Rejecting Cloud...","Evaluating Weissman Score...","Purging Local Storage...","Leaking Memory...","Scripting Python...","Grunting Ruby...","Benching RAM...","Determining Auxiliaries...","Jiggling Internet...","Ejecting Floppy...","Fluctuating Objects...","Spiking Reactor Core...","Firing Bosons...","Testing Processor...","Debugging Prompts...","Connecting Floats...","Rounding Integers...","Pronouncing Gigawatt...","Inverting Transponders...","Bypassing Silicon...","Raising Funds...","Caching Logs...","Dithering Broadband...","Eating Poutine...","Rolling Rims to Win...","Begging for Change...","Chasing Waterfalls...","Pumping Gas...","Emptying Pipes...","Hitting Piñata...","Unleashing Freedom...","Airbrushing Actors...","Filing Taxes...","Powering Mitochondria...","Calculating Qi charge...","Completing Geometry...","Turning in Algebra...","Solving for X...","Benching Wattage...","Kludging Playback Bar...","Stringifying Json...","Consuming Spaghetti Code...","Deleting Comments...","Transitioning to Django...","Learning to Code...","Battling Feature Creep...","Losing Flappy Bird...","Celebrating Good Times...","Sharpening Pencils...","Automating Processes...","Attacking Godzilla...","Carbonating Soda...","Thinking of Witty Text...","Opening Vault 111...","Ganking Lane...","Generating Puns...","Shaking it Off...","Adding Toppings...","Printing Stickers...","Spawning Meseeks...","Questioning Future...","Regretting Haircuts...","Finding Coupons...","Camping Spawn...","Defending Liberty...","Delivering Justice...","Saying Hello. Hello.","Hello World...","Folding Burritos...","Oiling Robots...","Pranking Dwight...","Hiding Jason’s Mouse...","Hiding Graham’s Phone...","Chasing Golden Snitch...","Insert Additional Quarters 1/2...","Hunting Walkers...","Warming Soup...","Sharpening Swords...","Petting Unicorns...","Solving Mysteries...","Feeding Scooby...","Refactoring Console Xors...","Anticipating Star Wars...","Counting to Christmas...","Respecting Elders...","Rendering Arrow in Knee...","Reviving Geralt...","Exploring Wasteland...","Ordering Martini...","Hatching Yoshi...","Combining Bits...","Stomping Goombas...","Rescuing Princess...","Finding True Love...","Videostream and Chilling...","Saving Companion Cube...","Saving Super…...","Rendering Checkpoint...","Loading Saves...","Feeding Fish...","Phoning Home...","Protecting VIP...","Shaking Buns...","Makin Bacon Pancakes...","Playing Pong...","Charging Batteries...","Backing up Data...","Burning to Disk...","Making New Friends...","Spawning Sims...")
    }

}
