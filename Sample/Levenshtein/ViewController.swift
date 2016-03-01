//
//  ViewController.swift
//  Levenshtein
//
//  Created by Cyril Chandelier on 01/07/15.
//  Copyright (c) 2015 Cyril Chandelier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak private var searchField: UITextField!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet private var hintView: UIView!
    @IBOutlet weak private var hintLabel: UILabel!
    var results: [String] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Hint view is initially hidden
        hintView.removeFromSuperview()
        tableView.tableHeaderView = nil
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        // Update hint label prefered layout width so it resize correctly when having multiple lines content
        hintLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - 2 * 15;
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellID")
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.textLabel?.text = results[indexPath.row].capitalizedString
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        search()
        
        return false
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool
    {
        textField.text = ""
        search()
        
        return false
    }
    
    // MARK: - Utils
    
    func search()
    {
        let searchString = searchField.text!
        
        // Cast dictionary into a filterable array using an NSArray
        let filterableArray = NSArray(array: dictionary)
        
        // Filter results and reload table view
        results = filterableArray.filteredArrayUsingPredicate(NSPredicate(format: "SELF CONTAINS[cd] %@", searchString)) as! [String]
        tableView.reloadData()
        
        // If there is no results, try to find close words
        self.tableView.tableHeaderView = nil
        if results.count == 0 && searchString.characters.count >= 2
        {
            let closeWords = closeWordsFrom(searchString, words: dictionary)
            if closeWords.count > 0
            {
                let hint = NSMutableAttributedString(string: "Did you mean: ")
                var i = 0
                for word in closeWords
                {
                    // Word separator according to word position
                    if i != 0 && i == closeWords.count - 1
                    {
                        hint.appendAttributedString(NSAttributedString(string: " or "))
                    }
                    else if i > 0
                    {
                        hint.appendAttributedString(NSAttributedString(string: ", "))
                    }
                    
                    // Append word in a different style
                    hint.appendAttributedString(NSAttributedString(string: word.uppercaseString, attributes: [
                        NSFontAttributeName : UIFont.boldSystemFontOfSize(17.0),
                        NSForegroundColorAttributeName : UIColor.blueColor()
                        ]))
                    i++
                }
                hint.appendAttributedString(NSAttributedString(string: "?"))
                
                // Resize and update table view header
                hintLabel.attributedText = hint
                tableView.tableHeaderView = hintView
                sizeHeaderToFit()
            }
        }
    }
    
    func closeWordsFrom(string: String, words: [String], treshold: Int = 2) -> [String]
    {
        var closeWords: [String] = []
        for word in words
        {
            let distance = string.levenshtein(word, caseSensitive: false, diacriticSensitive: false)
            if distance <= treshold
            {
                closeWords.append(word)
            }
        }
        
        return closeWords
    }
    
    func sizeHeaderToFit()
    {
        let headerView = tableView.tableHeaderView!
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        var frame = headerView.frame
        frame.size.height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - Data
    
    let dictionary = [ "frowardness", "reillustrate", "blackfire", "transferential", "hyperalgesia", "haidee", "neuromuscular", "precombating", "unappetizing", "harshen", "canonized", "semigeometric", "rhet", "hierogrammatic", "nonsoporific", "unabashedly", "tactile", "mellific", "hermaphroditus", "pointillist", "metallographer", "tornadolike", "garreteer", "mem", "nonofficial", "interindependence", "shardana", "nonequivocal", "uncontributed", "interequinoctial", "bridoon", "harebrainedness", "info", "extravagated", "hooded", "ferrotitanium", "grizzle", "inappreciable", "unamalgamable", "excorticate", "magus", "courteous", "nonzodiacal", "isoporic", "forecited", "detailedly", "overoptimistically", "jock", "unclench", "emanuel", "velamina", "cassiodorus", "pistol", "underogative", "spartacism", "izvestia", "marled", "prs", "frangipani", "focused", "damnyankee", "zenith", "branchiopod", "preagitation", "monotonal", "hydrosphere", "superimposing", "crossrail", "andikithira", "censer", "alvine", "myxomata", "lillie", "unintensified", "glacialist", "nonargumentative", "jugulating", "counterfeiter", "decancellation", "hypothecium", "slumming", "steatopygia", "unexuberant", "mandataries", "terroriser", "helvï¿¥ï¾½tius", "punctuative", "vendace", "monochromatically", "rumina", "apetaly", "callisto", "coleridge", "hanukkah", "bondstone", "creamcups", "peridotic", "continuator", "overpessimism", "palaeozoology", "incomprehensive", "equalling", "leviathan", "petrillo", "diametrically", "procurer", "dolefully", "dowelled", "lothsome", "unlabialising", "atlanta", "elver", "machinery", "top", "seminarcotic", "digammated", "prout", "dichotomous", "bride", "unmaltable", "nonsatisfaction", "lethargically", "senatorship", "stinkaroo", "oblongly", "prewarn", "suez", "comandante", "jacquerie", "subauditor", "medusoid", "teepee", "giovanni", "acetonic", "pronouncer", "unsacrificing", "chute", "roughcaster", "isocheimal", "inauspiciously", "stoutness", "cytostome", "mercurify", "mythified", "cycler", "auguste", "ephoral", "necrological", "anger", "xantippe", "guidebookish", "reconfusion", "decalogue", "hemiacetal", "gymnast", "balkanize", "copiousness", "waterford", "squintingly", "pterodactylid", "cosmoramic", "aoide", "spiracular", "screecher", "diglot", "forkedly", "haematomata", "dogbane", "indeterministic", "zaniest", "tirana", "toilworn", "mortifiedly", "laniferous", "caressively", "faizabad", "burr", "degustate", "semiallegorical", "polytonalism", "thalassocracy", "articular", "walkway", "unreached", "gerdie", "hamath", "vitruvius", "supersincerity", "unruffed", "ideaistic", "phrenic", "hermine", "brakeage", "abomasum", "dabble", "unextendible", "iscariotic", "vectorial", "gully", "courland", "jaana", "nondestructive", "concinnous", "brede", "ketchikan", "conn", "systematism", "subminiaturize", "austenitizing", "immunotherapy", "semiacidic", "seamiest", "overindustrializing", "damply", "impulsion", "callipash", "this", "monotone", "lamp", "unfrustrated", "discomposed", "feathercut", "gelatinization", "beniamino", "infusibleness", "aspersorium", "intercom", "isobath", "occupier", "stibine", "reinjury", "contemporized", "larruping", "antitype", "brevis", "antiministerial", "gorgonize", "crucifying", "vitelline", "subjectivism", "gramineous", "nagpur", "untarnished", "veratrine", "tragicomedy", "mouflon", "propitiative", "arany", "telsonic", "intruding", "dogmatizer", "pensionably", "alveolar", "misdoubt", "congeal", "unlaving", "bouilli", "menshevism", "gastightness", "cerebrovascular", "unprofiteering", "unfoul", "pseudocoelomate", "unextricated", "squinnied", "hypersusceptibility", "unmultipliable", "beerhouse", "learnedness", "karoo", "hopingly", "grunitsky", "captivator", "nonrealizing", "clubwoman", "theorbist", "pillar", "unpredicative", "branles", "unsedentary", "nonzonal", "aornum", "topsoil", "unsaleable", "despotically", "postumbonal", "reincreased", "dissolubleness", "allusiveness", "disaster", "sexily", "desk", "nevada", "dextrorotation", "studwork", "colet", "preinferring", "unpunctuality", "therein", "subengineer", "van", "sparrowlike", "forefeeling", "jaguarundi", "theoderic", "boundlessness", "listerizing", "gated", "sunlight", "prediscouragement", "prepurchasing", "dandruff", "symphonious", "unsuburban", "shunt", "unpleased", "kickable", "apterial", "beatty", "dizzier", "accusant", "entanglingly", "literate", "adjuratory", "uncapped", "transmissibility", "antiaristocratic", "limacine", "inrush", "converser", "outlandish", "postulator", "calker", "studied", "outstepped", "chamferer", "polycaste", "pitchier", "stonecast", "socialised", "overwinding", "availability", "predecreed", "kaolinite", "multiengine", "unliberal", "unfigurative", "ungossiping", "classicize", "strode", "sarsaparilla", "nonsequestration", "mobbishly", "clinician", "microconstituent", "vernier", "hortatively", "undivertible", "ungross", "intermittent", "heis", "unhedging", "savate", "hazy", "unrevealed", "syllabification", "presage", "wanion", "cadaverously", "interownership", "agatoid", "compluvium", "onrush", "musil", "chloroacetone", "superastonishment", "eloise", "chilung", "lollardry", "millboard", "sango", "pluckiness", "wireworm", "brasserie", "wettest", "cotemporaries", "nonfiduciaries", "regraded", "decolor", "chambers", "frivolity", "hydragog", "unexhorted", "kernelless", "sild", "antliliae", "reweld", "juniority", "pectolite", "nomination", "ninevitical", "caseinogen", "conciliating", "premarital", "soignï¿¥ï¾½", "devourer", "overflavor", "nonarithmetical", "widget", "sorrier", "finalist", "heterochromous", "bowel", "sunshineless", "saltato", "overdedicate", "hemotherapy", "brisbane", "helminth", "guy", "hackman", "seriously", "spasmophilia", "intercolonizing", "unpieced", "textuaries", "diadochi", "edentata", "rinsing", "sophy", "fulmination", "kelebe", "slavishly", "ochlocrat", "upshot", "demureness", "portfire", "outgnawing", "madder", "toyotomi", "imbitterer", "reviler", "airdropping", "conglobing", "weiser", "turnus", "invent", "undammed", "tachyauxetic", "bontoc", "colatitude", "unbluffed", "galvanizer", "spherulite", "distringas", "aesepus", "sociopsychological", "rentier", "retinitis", "nonstop", "overseeing", "sculk", "andron", "scatteringly", "ladyfish", "cleothera", "hematozoic", "bogy", "substage", "unacceptance", "bastide", "cleanliness", "stoper", "unhypnotized", "noncontrolling", "profitability", "rebelliously", "tenderly", "bordereau", "henbane", "radium", "noncondimental", "lumberjack", "schemata", "nestorianism", "geitonogamy", "overdescribed", "unsquabbling", "gone", "antheil", "trussville", "letterless", "conformer", "frontier", "instead", "arbuthnot", "nonpulmonary", "grandrelle", "bankable", "stockjobber", "arion", "untrustworthily", "desist", "meatuses", "statvolt", "sobor", "nonmysticism", "occultism", "unliving", "hosel", "orotundity", "decima", "hops", "emblazoner", "ehrenbreitstein", "unfarmable", "falcated", "xylographer", "heartrendingly", "nonconsolable", "protectorless", "bustler", "domelike", "unfocussed", "forjudgment", "thumb", "mssbauer", "carrousel", "mediocris", "reanalyzing", "devising", "dopier", "pine", "overfierce", "follow", "overdilute", "compliancy", "convalescing", "trichologist", "rostrum", "alienating", "delambre", "vladimir", "boatyard", "outsought", "omer", "homogeneously", "retinge", "hyolithid", "subsphenoidal", "somniloquy", "goodly", "escherichia", "unfeudalizing", "impugn", "fuzzy", "incipit", "redoubtableness", "irritatedly", "misdoer", "gluttonising", "selsyn", "biogeochemistry", "overillustrative", "axillaries", "enchanting", "incongruity", "epagogic", "deposable", "razor", "ivanovo", "amphibolous", "concretise", "capitulatory", "mulch", "pretasted", "tory", "physiognomy", "overprovident", "unvisored", "functionaries", "chloridize", "mythological", "scabble", "romanticism", "flying", "antieducationist", "hypoproteinemia", "unattractive", "undrenched", "robustness", "novobiocin", "headdress", "ultramontane", "undrubbed", "whencesoever", "jennifer", "hopper", "cestos", "unmalevolent", "inevitably", "nonsenatorial", "haematology", "nominated", "rarefactive", "arnold", "plaguey", "lyngi", "untentacled", "uncomplemented", "corroder", "lychnis", "conscriptionist", "lgth", "covenanter", "smelt", "coaxial", "immortelle", "jackeroo", "recursion", "kythe", "iridectomise", "freemason", "hockey", "pageantry", "panamic", "taylor", "panmixis", "reverter", "mersenne", "ament", "shovelhead", "quintus", "bhang", "otologist", "spinous", "emily", "conkers", "keelhaul", "taggard", "batteau", "nonliving", "bechuana", "firebird", "baffle", "quadrat", "gertie", "bilbo", "ponograph", "perjurious", "pistollike", "prelumbar", "min", "hunkers", "depreciatingly", "ail", "quango", "superseniority", "overlusty", "brightly", "botchily", "matriarch", "pyritohedron", "ungagging", "bulkily", "booze", "dario", "overgenerosity", "dahomey", "inconvertible", "parabolicalism", "disarmer", "uninitiate", "assemblage", "vicenni", "nonpreferableness", "ericeticolous", "stupidness", "hypoendocrinism", "flamboyant", "pauser", "subroot", "unnetted", "dimidiate", "nonassociation", "prepotently", "impetrative", "potentiometer", "comprisal", "fujiyama", "dooley", "suaveness", "materialiser", "hercegovina", "bloodlike", "gurjun", "unproofread", "semineurotically", "misbecoming", "newberg", "pseudoreformatory", "semimetaphoric", "agilawood", "renoir", "dorati", "posturized", "squacco", "unmoribund", "crab", "landowning", "dishful", "preconfer", "incited", "dupondii", "nonoligarchical", "analogousness", "rhapsodic", "peignoir", "leather", "discountenance", "circle", "uncharted", "cantabrigian", "maurya", "spline", "multispinous", "wilton", "myelinization", "glave", "limberneck", "superexpression", "subcancellate", "acervate", "bartholomew", "fredrik", "decoding", "hayato", "isodimorphous", "retwine", "jointed", "whare", "circumambulated", "caught", "anaphrodisiac", "transistorize", "sissonne", "autotomised", "insouciantly", "tuxedo", "pygostyled", "barothermogram", "gynaecium", "celesta", "viz", "quire", "brannigan", "unaccompanied", "siderostat", "unsmoothened", "overfix", "rush", "patriarchate", "nervy", "mahseer", "nonexistentialism", "omitted", "unsequent", "balkanising", "distilled", "reassort", "subproctor", "elie", "boarishness", "prebranchial", "prelature", "bijouterie", "greenwood", "malting", "romyko", "subordination", "dutiful", "homs", "ghostily", "duskiest", "asexualising", "stanton", "palatinate", "prerelationship", "lenes", "anticlerical", "fard", "prexistent", "nganhwei", "hay", "fugitive", "reauthorization", "discretional", "ungambling", "valetudinarianism", "reflectorizing", "underpile", "dubbo", "goldbricker", "cabal", "giulio", "telemechanics", "bloomfieldian", "shorewards", "overmasterful", "thornier", "muscadel", "superrefine", "sensing", "disposed", "feudalist", "ancohuma", "antimedicine", "overassuming", "noncontention", "monocycly", "algidity", "favourite", "noncorrupter", "clearstarcher", "stefansson", "plaintiffship", "waterdog", "fatuously", "defilingly", "lucullean", "unpermeated", "systemizable", "chauvinist", "psychotherapeutics", "revindication", "nevers", "stepdaughter", "talaria", "preterit", "percussional", "gaillard", "congregating", "pectate", "vorticellae", "unpalsied", "idiotic", "dissipate", "nonorientation", "unactionable", "nunhood", "forninst", "glace", "zwicky", "futhork", "overpaid", "lento", "preillumination", "catholicizing", "herzegovinian", "initialing", "remagnetizing", "hazemeter", "achromate", "middlebreaker", "flavonol", "untimeliness", "deianeira", "predistortion", "fatherless", "force", "perceptively", "spectrally", "arabinose", "hondo", "undergaoler", "caguas", "commotive", "spathe", "heterodactyl", "aquatint", "masked", "pataca", "manjack", "ada", "say", "kochi", "overexpress", "unevolved", "albuminuria", "votress", "imperfectible", "selectable", "blackheart", "cleruchy", "jobholder", "haussmann", "argumentum", "analyzer", "chinbeak", "embryotrophic", "candiot", "silesia", "nontheoretical", "dink", "unlavished", "spongier", "bestialising", "beef", "prewar", "releasible", "carpetless", "possessed", "substantively", "cocles", "birkhoff", "manichaeanism", "wheelabrator", "tarsia", "unpreordained", "caulonia", "pseudoencephalitic", "fizzier", "argo", "acetobacter", "refaced", "ferrotungsten", "acculturating", "reformed", "gib", "afrasia", "circuitously", "atomism", "glumaceous", "seaward", "galleylike", "nonbromidic", "insecure", "broilingly", "uninterrogable", "luau", "ethmoidal", "platypus", "occidentalizing", "kame", "scammoniate", "normalize", "cancha", "decency", "creaky", "unadmitted", "liminess", "slaking", "metropolitanism", "scalelike", "preevade", "ligular", "hijra", "deflower", "gilliflower", "smoothy", "mollify", "unsubmitting", "roscoe", "stannate", "keynesian", "olericulturally", "anole", "stoneware", "monosome", "outsee", "eurotas", "demoralized", "synchronoscope", "latticini", "angel", "onymous", "immiscible", "rigmarole", "landon", "unsuperscribed", "transgressively", "invocated", "anemochoric", "declivent", "gentlemanliness", "sicker", "moosemilk", "lycon", "reliquidation", "anytime", "indescribableness", "lunge", "angelina" ]
}

