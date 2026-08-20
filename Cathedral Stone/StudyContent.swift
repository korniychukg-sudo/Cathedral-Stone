import Foundation

struct CathedralEntry: Identifiable {
    let slug: String
    let name: String
    let place: String
    let dates: String
    let vaultHeight: Double
    let note: String
    var id: String { slug }
}

let cathedrals: [CathedralEntry] = cathedralsA + cathedralsB

let cathedralsA: [CathedralEntry] = [
    CathedralEntry(slug: "durham", name: "Durham", place: "England", dates: "1093–1133",
                   vaultHeight: 22,
                   note: "The first building in Europe to carry a high ribbed vault the whole length of its nave, and it did it with walls two metres thick and quadrant arches hidden in the triforium — flying buttresses in everything but name, forty years before anyone admitted to inventing them."),
    CathedralEntry(slug: "notredame", name: "Notre-Dame de Paris", place: "France",
                   dates: "1163–1345", vaultHeight: 33,
                   note: "Where the flying buttress came out into the open and stopped pretending to be part of the roof. The first ones were added when the thin clerestory wall began to move, which is to say the invention was a repair."),
    CathedralEntry(slug: "chartres", name: "Chartres", place: "France", dates: "1194–1220",
                   vaultHeight: 37,
                   note: "Built in twenty-six years after a fire, to one design, by one lodge — which is why it is coherent in a way almost nothing else of its date is. Two tiers of flyers, heavy pinnacled piers, and a clerestory that is nearly all glass."),
    CathedralEntry(slug: "reims", name: "Reims", place: "France", dates: "1211–1275",
                   vaultHeight: 38,
                   note: "Where bar tracery was invented: instead of piercing holes in a stone panel, thin moulded bars were assembled into a frame and glazed. Every later Gothic window in Europe descends from the Reims clerestory."),
]

let cathedralsB: [CathedralEntry] = [
    CathedralEntry(slug: "amiens", name: "Amiens", place: "France", dates: "1220–1270",
                   vaultHeight: 42,
                   note: "The tallest completed nave in France and about the practical limit of the system. Robert de Luzarches set it out with a nave so narrow relative to its height that standing in it is closer to standing in a shaft than a room."),
    CathedralEntry(slug: "beauvais", name: "Beauvais", place: "France", dates: "1225–1272",
                   vaultHeight: 48,
                   note: "Forty-eight metres, and it came down in 1284. The buttress piers were too far apart and too slender, the choir vault too high for them, and the whole thing folded exactly where limit analysis says it should. It was rebuilt with twice as many piers and never finished."),
    CathedralEntry(slug: "salisbury", name: "Salisbury", place: "England", dates: "1220–1258",
                   vaultHeight: 26,
                   note: "The English answer: build long and low rather than tall, on a green field, in one campaign, in thirty-eight years. The spire was added later and is the one part that has given trouble ever since."),
    CathedralEntry(slug: "cologne", name: "Cologne", place: "Germany", dates: "1248–1880",
                   vaultHeight: 43,
                   note: "Begun in the thirteenth century, abandoned in the sixteenth with a crane standing on the unfinished south tower, and completed in the nineteenth from the original drawings, which had survived. It is both mediaeval and Victorian and there is no seam."),
]

func cathedral(_ slug: String) -> CathedralEntry {
    cathedrals.first { $0.slug == slug } ?? cathedrals[0]
}

struct ElementEntry: Identifiable {
    let slug: String
    let title: String
    let sub: String
    let note: String
    var id: String { slug }
}

let elements: [ElementEntry] = elementsA + elementsB + elementsC

let elementsA: [ElementEntry] = [
    ElementEntry(slug: "pier-round", title: "The Round Pier", sub: "Romanesque",
                 note: "A rubble core with an ashlar skin, built as a drum. Enormously strong in compression and enormously heavy, and it takes up floor a later mason would want for people."),
    ElementEntry(slug: "pier-compound", title: "The Compound Pier", sub: "Core and shafts",
                 note: "Shafts attached to a core, each one running up to meet a rib or an arch above. Less stone than a drum, and it makes the structure legible: you can see where the load is going."),
    ElementEntry(slug: "pier-clustered", title: "The Clustered Pier", sub: "One shaft per rib",
                 note: "The logic taken to its end: a shaft for every member above, bundled together. Beautiful, efficient, and completely unforgiving of a vault heavier than it was drawn for."),
    ElementEntry(slug: "arch-round", title: "The Semicircular Arch", sub: "Roman",
                 note: "Its rise is fixed at half the span, so a wide bay is a low bay. That geometric constraint is the whole reason Romanesque churches are shaped as they are."),
    ElementEntry(slug: "arch-equilateral", title: "The Equilateral Arch", sub: "Two centres, one span apart",
                 note: "The commonest Gothic arch. Rises noticeably higher than a semicircle over the same span, so more of the load runs down and less pushes out."),
    ElementEntry(slug: "arch-lancet", title: "The Lancet Arch", sub: "Steep and narrow",
                 note: "The steeper the arch, the smaller the horizontal thrust — and the more freedom the mason has to put bays of different widths at the same height, which a semicircular arch never allows."),
    ElementEntry(slug: "vault-barrel", title: "The Barrel Vault", sub: "A tunnel of stone",
                 note: "Pushes outward along the entire length of both walls, which must therefore stay solid the whole way. It is the reason Romanesque interiors are dark."),
    ElementEntry(slug: "vault-groin", title: "The Groin Vault", sub: "Two barrels crossed",
                 note: "The load concentrates along the diagonal groins and arrives at four corners. The wall between the corners is suddenly doing less work, and can start to open up."),
]

let elementsB: [ElementEntry] = [
    ElementEntry(slug: "vault-rib", title: "The Rib Vault", sub: "Ribs first, web after",
                 note: "Build the ribs on light centring, then fill the panels between them with a thin web. Cheaper in timber, faster to build, and it puts every load on four points."),
    ElementEntry(slug: "vault-fan", title: "The Fan Vault", sub: "English, and a conceit",
                 note: "Every rib struck from the same curve, so the vault becomes a set of half-cones. It is cut from solid blocks rather than assembled, which makes it a mason's showpiece and an accountant's nightmare."),
    ElementEntry(slug: "butt-wall", title: "The Thick Wall", sub: "Mass everywhere",
                 note: "The oldest answer to thrust: put stone everywhere it might be needed. It works, and it costs you every window in the building."),
    ElementEntry(slug: "butt-clasping", title: "The Clasping Buttress", sub: "Mass where it is needed",
                 note: "The same mass, gathered at the points where the vault actually pushes. Between the buttresses the wall can be thinned, and that thinning is where Gothic begins."),
    ElementEntry(slug: "butt-flying", title: "The Flying Buttress", sub: "Thrust carried out",
                 note: "A half-arch flung over the aisle to a free-standing pier. It does not hold the wall up; it takes the sideways push across to somewhere heavy enough to turn it down."),
    ElementEntry(slug: "pinnacle", title: "The Pinnacle", sub: "Weight, dressed as ornament",
                 note: "Adding weight on top of a buttress pier steepens the resultant of thrust and self-weight, and steers the thrust line back inside the base. The crockets are camouflage."),
    ElementEntry(slug: "tracery", title: "Bar Tracery", sub: "Stone reduced to what carries",
                 note: "Thin moulded bars assembled into a frame instead of holes cut in a plate. Invented at Reims and it changed what a wall could be everywhere in Europe within a generation."),
    ElementEntry(slug: "rose", title: "The Rose Window", sub: "A wheel of glass",
                 note: "Structurally the most alarming thing in the building: a large circular hole in a wall that is carrying a roof. It survives because the wall around it is thickened into a ring."),
]

let elementsC: [ElementEntry] = [
    ElementEntry(slug: "boss", title: "The Boss", sub: "Where the ribs meet",
                 note: "The keystone of a rib vault, carved after it was set. It locks four or six ribs together and it is the last stone to go in, which is why it is the one that gets the carving."),
    ElementEntry(slug: "gargoyle", title: "The Gargoyle", sub: "A spout, not an ornament",
                 note: "Throws rainwater clear of the wall. Water running down masonry freezes in the joints and takes the face off the stone, so every one of these is doing structural work."),
    ElementEntry(slug: "scaffold", title: "The Scaffold", sub: "Putlogs and hurdles",
                 note: "Timber poles lashed together, bedded into holes left in the wall. Those putlog holes are still visible on most mediaeval buildings if you know to look for the regular square gaps."),
    ElementEntry(slug: "crane", title: "The Treadwheel Crane", sub: "Two men and a rope",
                 note: "A great wheel walked from inside by two men, geared to a drum. It lifted every stone in every cathedral in Europe, and one was left standing on the unfinished tower at Cologne for three hundred years."),
]

func element(_ slug: String) -> ElementEntry {
    elements.first { $0.slug == slug } ?? elements[0]
}

struct Lesson: Identifiable {
    let slug: String
    let title: String
    let standfirst: String
    let paragraphs: [String]
    var id: String { slug }
}

let lessons: [Lesson] = lessonSetA + lessonSetB + lessonSetC

let lessonSetA: [Lesson] = [
    Lesson(slug: "thrust", title: "Stone Pushes Sideways",
           standfirst: "An arch does not only press down.",
           paragraphs: [
            "Put a beam across two supports and it presses straight down on them. Put an arch across the same gap and it presses down and outward at once, and the outward push does not go away when you stop looking at it.",
            "That horizontal push is thrust, and it is the single fact that governs every decision in a masonry building. It is why Romanesque walls are thick, why Gothic buttresses exist, and why Beauvais fell down.",
            "The size of it depends on two things: how heavy the arch is, and how high it rises for its span. Heavier means more; flatter means much more.",
            "A rough figure for the thrust of an arch is the load times the span divided by eight times the rise. Halve the rise and you double the push."])
    ,
    Lesson(slug: "thrust-line", title: "The Line of Thrust",
           standfirst: "Draw the path the load actually takes.",
           paragraphs: [
            "Imagine a chain hanging between two points. It takes up a shape in which every link is purely in tension — the funicular. Turn that shape upside down and you have a line in which every point is purely in compression.",
            "That inverted line is the line of thrust, and it is the path the load takes down through your masonry. Robert Hooke worked this out in 1675 and wrote it in Latin as an anagram so that nobody could steal it.",
            "The rule that follows is simple and complete: if a line of thrust can be drawn that stays inside the masonry everywhere, the structure will stand. If no such line exists, it will not.",
            "It is a limit theorem, not a prediction. It does not tell you what the stresses are. It tells you whether collapse is possible, which for a masonry building is the only question that matters."])
    ,
    Lesson(slug: "middle-third", title: "The Middle Third",
           standfirst: "Inside the stone is not the same as safe.",
           paragraphs: [
            "If the thrust line stays within the middle third of a section, the whole joint is in compression and nothing opens. That is the comfortable condition and it is what a good mason aims at.",
            "If it strays outside the middle third but stays inside the section, the joint opens on one face. The masonry cracks, redistributes and carries on. Half the mediaeval buildings in Europe are standing in exactly this condition and have been for eight hundred years.",
            "If the line leaves the section altogether, there is nothing to resist the moment. The joint becomes a hinge.",
            "So there are three states, not two: safe, cracked, and gone. Cracked is not failure — but a crack tells you precisely where the line is running, which is why masons read them."])
    ,
    Lesson(slug: "pointed-arch", title: "Why the Arch Was Pointed",
           standfirst: "Not for the look of it.",
           paragraphs: [
            "A semicircular arch rises exactly half its span. That is a geometric fact and it cannot be argued with: a wide bay must be a low arch, and a low arch pushes hard.",
            "A pointed arch is struck from two centres, so its rise is a free choice. The same span can be carried at any height you like.",
            "Two things follow. First, the thrust drops — a sharp lancet pushes out roughly half as hard as a semicircle over the same span. Second, and just as important, bays of different widths can be brought to the same height, which is what makes a complicated plan possible at all.",
            "The pointed arch was known in the Islamic world long before it reached northern Europe. What was new in the twelfth century was using it systematically, everywhere, as the solution to a structural problem."])
]

let lessonSetB: [Lesson] = [
    Lesson(slug: "rib-vault", title: "Gathering the Load",
           standfirst: "Four points instead of two walls.",
           paragraphs: [
            "A barrel vault pushes outward along the whole length of the wall beneath it. There is nowhere on that wall you can safely remove stone.",
            "Cross two barrels and the load runs down the diagonal groins to four corners. Now the wall between the corners is carrying much less, and can be opened.",
            "Add ribs along those diagonals — build them first, on light centring, and fill the panels afterwards with a thin web — and you have a rib vault. It is lighter, it needs far less timber, and each bay can be built and struck independently.",
            "That is the whole Gothic move: gather the load onto points, buttress the points, and glaze everything in between. Everything else follows from it."])
    ,
    Lesson(slug: "flying", title: "Carrying It Out",
           standfirst: "The flyer does not hold anything up.",
           paragraphs: [
            "The high vault pushes outward at its springing, thirty metres up. There is nothing at that height to resist it, because the wall there has been cut away for windows.",
            "A flying buttress is a half-arch that reaches across the aisle roof from the springing to a heavy free-standing pier outside. It carries the thrust horizontally to somewhere it can be dealt with.",
            "It is not holding the wall up. The wall is perfectly capable of carrying its own weight. The flyer is transmitting a horizontal force, and if you took it away the wall would move outward rather than downward.",
            "Two tiers are common: an upper one at the vault springing and a lower one to take wind load on the high roof. Chartres has two, and Chartres is still standing."])
    ,
    Lesson(slug: "pinnacle-weight", title: "What the Pinnacle Is For",
           standfirst: "It is weight, dressed as decoration.",
           paragraphs: [
            "At the top of the buttress pier, two forces meet: the horizontal thrust coming in along the flyer, and the vertical weight of the pier itself. Their resultant is a sloping line, and that line has to come down inside the pier.",
            "If the thrust is large and the pier is light, the resultant slopes too far and leaves the base. Add weight at the top and the resultant steepens, and comes down inside.",
            "That is what a pinnacle does. Every crocketed spire on every buttress pier in northern Europe is a counterweight with a haircut.",
            "You can watch it work: put a tall pinnacle on a marginal design and the thrust line at the base moves visibly inward. Take it off and it moves back out."])
    ,
    Lesson(slug: "hinges", title: "How Masonry Fails",
           standfirst: "Not by crushing. By turning into a mechanism.",
           paragraphs: [
            "Stone is enormously strong in compression. In a cathedral the working stress is typically a fortieth of what the limestone could actually take, so crushing is almost never the failure mode.",
            "What happens instead is that joints open. A joint that has opened is a hinge, and a hinge can rotate.",
            "One hinge is nothing. Two is nothing. Three is still a stable arrangement. The fourth hinge turns the arch into a four-bar linkage — a mechanism — and a mechanism has no strength at all. It folds.",
            "This is why cracks matter so much and why they are read so carefully. Each one marks a hinge, and counting them tells you how close the structure is to becoming a machine."])
]

let lessonSetC: [Lesson] = [
    Lesson(slug: "foundations", title: "What Is Underneath",
           standfirst: "Half of the failures were never about the stone.",
           paragraphs: [
            "The footing has to spread the load until the ground beneath can carry it. Mediaeval footings were often a stepped pyramid of rough stone, going down to whatever the masons judged firm.",
            "They had no way to test the ground except to dig it and look, which means a great deal depended on the judgement of a man standing in a hole.",
            "Differential settlement — one pier sinking more than its neighbour — is the commonest chronic problem in surviving buildings. It shows as leaning piers, distorted arches and long diagonal cracks.",
            "Winchester's east end was underpinned in 1906 by a diver, William Walker, who worked for six years in the dark in flooded peat, placing bags of concrete by hand."])
    ,
    Lesson(slug: "centring", title: "Building on Air",
           standfirst: "An arch does nothing until it is finished.",
           paragraphs: [
            "Until the last stone is in place, an arch is a row of blocks that will fall down. Every one was therefore built on a timber former called the centring, shaped to the intended curve.",
            "Striking the centring — lowering it away and leaving the arch to stand on its own — was the moment of truth, and it was done gradually, on wedges, so the arch settled rather than dropped.",
            "Timber was expensive and skilled carpentry more so. A significant part of the cost of any great church was the wood that held it up while it was being built, and the same centring was moved from bay to bay and used until it wore out.",
            "The rib vault's real economy is here: the ribs need only light centring, and once they are up the web panels can be built off them with almost none."])
    ,
    Lesson(slug: "beauvais", title: "The One That Fell",
           standfirst: "Forty-eight metres, and twelve years.",
           paragraphs: [
            "Beauvais set out in 1225 to build the tallest choir in Christendom, and finished it in 1272 at forty-eight metres. In 1284 a large part of it collapsed.",
            "The analysis is not mysterious. The buttress piers were widely spaced and slender for their height; the intermediate piers took wind and vault thrust that they were not sized for; and the whole design pushed the thrust line very close to the edge of the section everywhere.",
            "It was rebuilt with the bay spacing halved — twice as many piers — and the choir stands today. The nave was never built, and a tower added in the sixteenth century fell down as well.",
            "Beauvais is worth knowing because it is the boundary of the system. Amiens at forty-two metres is the practical limit; six metres more turned out to be six metres too many."])
    ,
    Lesson(slug: "geometry", title: "The Tracing Floor",
           standfirst: "No drawings to scale, and no arithmetic.",
           paragraphs: [
            "Mediaeval masons did not calculate. They had no algebra worth the name and Arabic numerals were only beginning to arrive. What they had was geometry, a cord, a straight edge and a pair of compasses.",
            "Details were set out full size on a floor spread with plaster — a tracing floor. Two survive, at Wells and at York, with the incised lines still visible.",
            "Proportions were derived rather than chosen: ad quadratum, working from a square and its diagonal; ad triangulum, from an equilateral triangle. Both give irrational ratios that a mason could construct exactly with compasses and never write down as a number.",
            "This is why the rules of thumb mattered so much. A mason knew that a buttress should be a quarter of the height of the vault it carried, not because he had calculated it, but because that is what stood."])
]

struct GlossaryTerm: Identifiable {
    let term: String
    let meaning: String
    var id: String { term }
}

let glossary: [GlossaryTerm] = glossA + glossB + glossC + glossD + glossE

let glossA: [GlossaryTerm] = [
    GlossaryTerm(term: "Thrust", meaning: "The horizontal push an arch or vault exerts on whatever carries it."),
    GlossaryTerm(term: "Line of thrust", meaning: "The path the load actually takes down through the masonry. Inside the stone, it stands."),
    GlossaryTerm(term: "Funicular", meaning: "The shape a hanging chain takes. Inverted, it is a line of pure compression."),
    GlossaryTerm(term: "Middle third", meaning: "The central third of a section. A thrust line inside it opens no joint at all."),
    GlossaryTerm(term: "Hinge", meaning: "An opened joint about which masonry can rotate. Four of them make a mechanism."),
    GlossaryTerm(term: "Mechanism", meaning: "A linkage with no strength. What a masonry arch becomes at the fourth hinge."),
    GlossaryTerm(term: "Limit analysis", meaning: "Asking not what the stresses are but whether collapse is possible at all."),
    GlossaryTerm(term: "Eccentricity", meaning: "How far off centre the thrust line falls on a section."),
    GlossaryTerm(term: "Springing", meaning: "The level at which an arch begins to curve away from its support."),
]

let glossB: [GlossaryTerm] = [
    GlossaryTerm(term: "Voussoir", meaning: "One of the wedge-shaped stones of an arch."),
    GlossaryTerm(term: "Keystone", meaning: "The voussoir at the crown, put in last."),
    GlossaryTerm(term: "Centring", meaning: "The timber former an arch is built on and struck from."),
    GlossaryTerm(term: "Striking", meaning: "Lowering the centring away and leaving the arch to stand alone."),
    GlossaryTerm(term: "Extrados", meaning: "The outer surface of an arch."),
    GlossaryTerm(term: "Intrados", meaning: "The inner surface of an arch. Also the soffit."),
    GlossaryTerm(term: "Rise", meaning: "The height from springing to crown. A pointed arch can have any rise it likes."),
    GlossaryTerm(term: "Span", meaning: "The clear distance an arch crosses."),
    GlossaryTerm(term: "Haunch", meaning: "The part of an arch between springing and crown, where thrust lines are most awkward."),
]

let glossC: [GlossaryTerm] = [
    GlossaryTerm(term: "Nave", meaning: "The main body of the church, west of the crossing."),
    GlossaryTerm(term: "Aisle", meaning: "The lower space flanking the nave, and what a flyer has to cross."),
    GlossaryTerm(term: "Arcade", meaning: "The row of arches between nave and aisle."),
    GlossaryTerm(term: "Triforium", meaning: "The middle storey, over the aisle roof and under the clerestory."),
    GlossaryTerm(term: "Clerestory", meaning: "The upper wall of the nave, pierced with windows above the aisle roof."),
    GlossaryTerm(term: "Bay", meaning: "One repeating structural unit of the building, between two piers."),
    GlossaryTerm(term: "Crossing", meaning: "Where nave and transepts meet, and usually where the tower sits."),
    GlossaryTerm(term: "Chevet", meaning: "The east end with its ring of radiating chapels."),
    GlossaryTerm(term: "Ambulatory", meaning: "The aisle that runs round behind the high altar."),
]

let glossD: [GlossaryTerm] = [
    GlossaryTerm(term: "Rib", meaning: "A moulded arch built first, carrying the web of a vault."),
    GlossaryTerm(term: "Web", meaning: "The thin panel of stone filling the space between ribs."),
    GlossaryTerm(term: "Boss", meaning: "The carved keystone where ribs meet."),
    GlossaryTerm(term: "Quadripartite", meaning: "A rib vault divided into four cells by two diagonals."),
    GlossaryTerm(term: "Sexpartite", meaning: "Six cells, from an extra transverse rib across the middle."),
    GlossaryTerm(term: "Tierceron", meaning: "An extra rib running from springing to ridge, decorative more than structural."),
    GlossaryTerm(term: "Lierne", meaning: "A short rib joining two other ribs, touching neither springing nor crown."),
    GlossaryTerm(term: "Ashlar", meaning: "Squared, dressed stone laid in regular courses."),
    GlossaryTerm(term: "Rubble core", meaning: "The unshaped fill between two ashlar faces. Most mediaeval walls are mostly this."),
]

let glossE: [GlossaryTerm] = [
    GlossaryTerm(term: "Putlog hole", meaning: "The square hole left where a scaffold pole was bedded into the wall."),
    GlossaryTerm(term: "Banker mason", meaning: "The mason who cuts stone at a bench, as against the one who sets it."),
    GlossaryTerm(term: "Templet", meaning: "A thin board cut to a moulding profile, used to check every stone of a course."),
    GlossaryTerm(term: "Tracing floor", meaning: "A plaster floor on which details were set out full size. Two survive."),
    GlossaryTerm(term: "Ad quadratum", meaning: "Proportion derived from a square and its diagonal."),
    GlossaryTerm(term: "Ad triangulum", meaning: "Proportion derived from an equilateral triangle."),
    GlossaryTerm(term: "Lodge", meaning: "The workshop and the body of masons attached to a building."),
    GlossaryTerm(term: "Master mason", meaning: "The designer and site director. There was no separate profession of architect."),
    GlossaryTerm(term: "Fabric roll", meaning: "The account of money spent on the building. Most of what is known about costs comes from these."),
]

struct QuizQuestion: Identifiable {
    let prompt: String
    let options: [String]
    let answer: Int
    let note: String
    var id: String { prompt }
}

let quizQuestions: [QuizQuestion] = quizA + quizB + quizC + quizD

let quizA: [QuizQuestion] = [
    QuizQuestion(prompt: "What does an arch do that a beam does not?",
                 options: ["Push outward as well as down", "Carry more weight",
                           "Span further", "Need no support"],
                 answer: 0,
                 note: "That outward push is thrust, and it governs every decision in a masonry building."),
    QuizQuestion(prompt: "Halving the rise of an arch does what to its thrust?",
                 options: ["Roughly doubles it", "Roughly halves it",
                           "Leaves it unchanged", "Removes it"],
                 answer: 0,
                 note: "Thrust is about load times span over eight times the rise. Flatter is much worse."),
    QuizQuestion(prompt: "What is the line of thrust?",
                 options: ["The path the load takes down through the masonry",
                           "The centre line of the wall", "The line of the foundations",
                           "The crack pattern"],
                 answer: 0,
                 note: "It is an inverted hanging chain, and Hooke published it as an anagram in 1675."),
    QuizQuestion(prompt: "When will a masonry structure stand?",
                 options: ["If a thrust line can be drawn that stays inside the stone",
                           "If the stress is below the crushing strength",
                           "If the walls are thicker than a metre",
                           "If it has flying buttresses"],
                 answer: 0,
                 note: "That is the safe theorem of limit analysis, and for masonry it is the whole story."),
    QuizQuestion(prompt: "The thrust line inside the middle third means…",
                 options: ["No joint opens anywhere", "The structure is about to fail",
                           "The stone is crushing", "A hinge has formed"],
                 answer: 0,
                 note: "Outside the middle third but inside the section, it cracks and carries on."),
    QuizQuestion(prompt: "How many hinges turn an arch into a mechanism?",
                 options: ["Four", "One", "Two", "Six"],
                 answer: 0,
                 note: "Three hinges is still a stable arrangement. The fourth is the one that folds it."),
    QuizQuestion(prompt: "Why is crushing almost never the failure mode?",
                 options: ["Working stresses are a small fraction of the stone's strength",
                           "Stone does not crush", "The mortar takes the load",
                           "The walls are always thick enough"],
                 answer: 0,
                 note: "A cathedral typically works its limestone at about a fortieth of its capacity."),
    QuizQuestion(prompt: "What is the rise of a semicircular arch?",
                 options: ["Exactly half the span", "Any value the mason chooses",
                           "Equal to the span", "A third of the span"],
                 answer: 0,
                 note: "That geometric constraint is what shapes every Romanesque interior."),
]

let quizB: [QuizQuestion] = [
    QuizQuestion(prompt: "What is the main structural advantage of the pointed arch?",
                 options: ["The rise is a free choice, so the thrust can be reduced",
                           "It is stronger in compression", "It needs no centring",
                           "It uses fewer stones"],
                 answer: 0,
                 note: "And it lets bays of different widths reach the same height, which a semicircle never allows."),
    QuizQuestion(prompt: "What does a rib vault do to the load?",
                 options: ["Gathers it onto four points", "Spreads it evenly along the wall",
                           "Reduces it by half", "Sends it upward"],
                 answer: 0,
                 note: "Once the load is on four points, the wall between them can be glazed."),
    QuizQuestion(prompt: "What does a flying buttress actually do?",
                 options: ["Carries horizontal thrust out to a heavy pier",
                           "Holds the wall up", "Supports the roof",
                           "Stiffens the vault"],
                 answer: 0,
                 note: "The wall can carry its own weight perfectly well. It is the sideways push that needs help."),
    QuizQuestion(prompt: "What is a pinnacle for?",
                 options: ["Adding weight so the resultant comes down inside the pier",
                           "Marking the bay divisions", "Shedding rainwater",
                           "Housing a bell"],
                 answer: 0,
                 note: "Every crocketed spire on a buttress pier in Europe is a counterweight with a haircut."),
    QuizQuestion(prompt: "Why was the rib vault cheaper to build?",
                 options: ["The ribs need only light centring and the web needs almost none",
                           "It used less stone by weight", "It needed no scaffolding",
                           "Ribs were prefabricated"],
                 answer: 0,
                 note: "Timber and skilled carpentry were a large share of the cost of any great church."),
    QuizQuestion(prompt: "What is striking the centring?",
                 options: ["Lowering the timber former away so the arch stands alone",
                           "Setting the keystone", "Cutting the ribs",
                           "Removing the scaffold"],
                 answer: 0,
                 note: "Done gradually on wedges, so the arch settles instead of dropping."),
    QuizQuestion(prompt: "How high is the vault at Beauvais?",
                 options: ["48 metres", "42 metres", "37 metres", "26 metres"],
                 answer: 0,
                 note: "Finished in 1272 and partly collapsed in 1284. Amiens at 42 m is the practical limit."),
    QuizQuestion(prompt: "Why did Beauvais collapse?",
                 options: ["Buttress piers too slender and too widely spaced for the height",
                           "Poor mortar", "A fire", "Foundation failure alone"],
                 answer: 0,
                 note: "Rebuilt with the bay spacing halved, and that part is standing today."),
]

let quizC: [QuizQuestion] = [
    QuizQuestion(prompt: "What is bar tracery?",
                 options: ["Thin moulded bars assembled into a window frame",
                           "Holes cut in a stone plate", "Iron reinforcement in glass",
                           "The pattern of ribs in a vault"],
                 answer: 0,
                 note: "Invented at Reims, and every later Gothic window in Europe descends from it."),
    QuizQuestion(prompt: "What is a gargoyle for?",
                 options: ["Throwing rainwater clear of the wall",
                           "Frightening away evil", "Marking bay divisions",
                           "Ventilating the roof space"],
                 answer: 0,
                 note: "Water running down masonry freezes in the joints and takes the face off the stone."),
    QuizQuestion(prompt: "What is a putlog hole?",
                 options: ["Where a scaffold pole was bedded into the wall",
                           "A drainage channel", "A lifting socket for a crane",
                           "A joint left for settlement"],
                 answer: 0,
                 note: "Still visible on most mediaeval buildings as regular square gaps in the coursing."),
    QuizQuestion(prompt: "How were mouldings kept consistent from stone to stone?",
                 options: ["A templet — a board cut to the profile",
                           "By eye", "With a standard chisel set",
                           "From a scale drawing"],
                 answer: 0,
                 note: "Every stone of a course was checked against the same board."),
    QuizQuestion(prompt: "What was a tracing floor?",
                 options: ["A plaster floor for setting details out full size",
                           "The floor of the crossing", "A drawing office",
                           "The pattern of the pavement"],
                 answer: 0,
                 note: "Two survive, at Wells and at York, with the incised lines still there."),
    QuizQuestion(prompt: "Ad quadratum proportion is derived from…",
                 options: ["A square and its diagonal", "An equilateral triangle",
                           "The golden section", "The span of the nave"],
                 answer: 0,
                 note: "Ad triangulum is the other system. Both give ratios you can construct and never write down."),
    QuizQuestion(prompt: "Who directed the design and the site?",
                 options: ["The master mason", "The bishop", "A separate architect",
                           "The carpenter"],
                 answer: 0,
                 note: "There was no separate profession of architect. The master mason was both."),
    QuizQuestion(prompt: "What is a fabric roll?",
                 options: ["The account of money spent on the building",
                           "The plan drawn on cloth", "The list of masons' marks",
                           "The bishop's licence to build"],
                 answer: 0,
                 note: "Most of what is known about mediaeval building costs comes from these accounts."),
]

let quizD: [QuizQuestion] = [
    QuizQuestion(prompt: "Which building carried the first high ribbed vault along a whole nave?",
                 options: ["Durham", "Notre-Dame de Paris", "Chartres", "Amiens"],
                 answer: 0,
                 note: "Begun 1093, and with quadrant arches hidden in the triforium doing the work of flyers."),
    QuizQuestion(prompt: "Where did the flying buttress first appear openly?",
                 options: ["Notre-Dame de Paris", "Durham", "Salisbury", "Cologne"],
                 answer: 0,
                 note: "Added when the thin clerestory wall began to move — the invention was a repair."),
    QuizQuestion(prompt: "Why is Chartres unusually coherent?",
                 options: ["Built in twenty-six years to one design by one lodge",
                           "It was never altered", "It was built twice",
                           "It was designed by a committee"],
                 answer: 0,
                 note: "After the fire of 1194, and it set the pattern every later cathedral copied."),
    QuizQuestion(prompt: "What is unusual about Cologne?",
                 options: ["Begun in 1248, abandoned, and completed in 1880 from the original drawings",
                           "It has no flying buttresses", "It was built in one campaign",
                           "It is entirely of brick"],
                 answer: 0,
                 note: "A crane stood on the unfinished south tower for three centuries."),
    QuizQuestion(prompt: "What is the English answer to the height race?",
                 options: ["Build long and low, as at Salisbury",
                           "Build in brick", "Use iron ties", "Double the buttresses"],
                 answer: 0,
                 note: "Salisbury: one campaign, thirty-eight years, twenty-six metres, and no trouble since."),
    QuizQuestion(prompt: "What does differential settlement look like?",
                 options: ["Leaning piers and long diagonal cracks",
                           "Spalling stone faces", "Open joints at the crown only",
                           "Bowed window tracery"],
                 answer: 0,
                 note: "One pier sinking more than its neighbour. The commonest chronic fault in surviving buildings."),
    QuizQuestion(prompt: "Which is stronger evidence that a building is safe?",
                 options: ["A thrust line can be drawn inside the stone",
                           "It has stood for centuries",
                           "The stone is high quality", "The walls are thick"],
                 answer: 0,
                 note: "Standing is evidence, but the theorem is proof: if such a line exists, collapse is impossible."),
    QuizQuestion(prompt: "A crack in a vault tells you…",
                 options: ["Where a hinge has formed and roughly where the thrust runs",
                           "That the mortar has failed", "That the foundations moved",
                           "Nothing useful"],
                 answer: 0,
                 note: "Which is why masons read cracks rather than simply filling them."),
]

struct Award: Identifiable {
    let slug: String
    let name: String
    let requirement: String
    let test: (LodgeStore) -> Bool
    var id: String { slug }
}

let allAwards: [Award] = awardSetA + awardSetB + awardSetC

let awardSetA: [Award] = [
    Award(slug: "first", name: "First Course Laid", requirement: "Complete your first design",
          test: { $0.churches.count >= 1 }),
    Award(slug: "ten", name: "Ten Designs", requirement: "Complete ten designs",
          test: { $0.churches.count >= 10 }),
    Award(slug: "standing", name: "It Stands", requirement: "Build one that stands",
          test: { $0.standing >= 1 }),
    Award(slug: "uncracked", name: "Not a Joint Open", requirement: "Build one with the line inside the middle third",
          test: { $0.uncracked >= 1 }),
    Award(slug: "five-uncracked", name: "Five Without a Crack", requirement: "Build five with the line inside the middle third",
          test: { $0.uncracked >= 5 }),
    Award(slug: "collapse", name: "A Lesson Paid For", requirement: "Bring one down",
          test: { $0.collapses >= 1 }),
]

let awardSetB: [Award] = [
    Award(slug: "abbey", name: "The Abbey", requirement: "Stand up an abbey church",
          test: { $0.churches.contains { $0.stands && $0.programme == "abbey" } }),
    Award(slug: "cathedral", name: "The Cathedral", requirement: "Stand up a cathedral",
          test: { $0.churches.contains { $0.stands && $0.programme == "cathedral" } }),
    Award(slug: "beauvais", name: "Higher Than Amiens", requirement: "Stand up the Beauvais commission",
          test: { $0.churches.contains { $0.stands && $0.programme == "beauvais" } }),
    Award(slug: "master", name: "Master Mason", requirement: "Earn the grade of master mason",
          test: { $0.churches.contains { $0.grade == "Master mason" } }),
    Award(slug: "light", name: "A Wall of Glass", requirement: "Reach ninety per cent light on a standing design",
          test: { ($0.bestLight ?? 0) >= 0.90 }),
    Award(slug: "fan", name: "The Showpiece", requirement: "Stand up a fan vault",
          test: { $0.churches.contains { $0.stands && $0.vault == "vault-fan" } }),
]

let awardSetC: [Award] = [
    Award(slug: "no-flyers", name: "Without Flying", requirement: "Stand up a cathedral with no flying buttress",
          test: { $0.churches.contains { $0.stands && $0.programme != "parish"
                                         && !$0.buttress.contains("flying") } }),
    Award(slug: "clustered", name: "Shafts and Nerve", requirement: "Stand up a design on clustered piers",
          test: { $0.churches.contains { $0.stands && $0.pier == "pier-clustered" } }),
    Award(slug: "read-all", name: "The Whole Instruction", requirement: "Read all twelve lessons",
          test: { $0.readLessons.count >= lessons.count }),
    Award(slug: "elements", name: "The Lodge Book", requirement: "Open every element plate",
          test: { $0.metElements.count >= elements.count }),
    Award(slug: "cathedrals", name: "The Eight", requirement: "Read all eight cathedrals",
          test: { $0.metCathedrals.count >= cathedrals.count }),
    Award(slug: "quiz", name: "Examined", requirement: "Score at least fourteen of sixteen on the examination",
          test: { $0.quizBest >= 14 }),
]

func programme(_ slug: String) -> Programme {
    programmes.first { $0.slug == slug } ?? programmes[0]
}
