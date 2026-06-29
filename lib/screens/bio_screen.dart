import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/tracks_data.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 34, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('BIOGRAPHIE', style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: Image.asset('assets/images/pochette.jpg', fit: BoxFit.cover, alignment: Alignment.topCenter),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 140,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF121212)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kArtistName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const Text(
                        'RAP · ÉPINAY-SUR-SEINE',
                        style: TextStyle(color: Color(0xFFE8C547), fontSize: 12, letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boutons réseaux sociaux
                  Row(
                    children: [
                      _SocialButton(
                        label: 'Instagram',
                        icon: Icons.camera_alt_outlined,
                        color: const Color(0xFFE1306C),
                        onTap: () => _openUrl('https://www.instagram.com/doosay.revenge?igsh=M3g2Z2FmYTk5OWtt'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'TikTok',
                        icon: Icons.music_note_rounded,
                        color: Colors.white,
                        onTap: () => _openUrl('https://www.tiktok.com/@doosay.original'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'YouTube',
                        icon: Icons.play_circle_outline_rounded,
                        color: const Color(0xFFFF0000),
                        onTap: () => _openUrl('https://www.youtube.com/@doosaydelepok'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Intro
                  const Text(
                    'DOOSAY, de son vrai nom Seydou N\'Diaye, est un rappeur français d\'Épinay-sur-Seine. Originaire du quartier d\'Orgemont, il fait ses armes en Seine-Saint-Denis au côté de Halte-S, avec qui il formera pendant 12 ans le duo VERIDIK SECTION.\n\n'
                    'En 2019, il prend activement part à la formation du collectif Gêne2Génie en compagnie de MR PHIF & de 21Gram\' (COMOP) et sort plusieurs EP à un rythme effréné.',
                    style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15, height: 1.8),
                  ),
                  const SizedBox(height: 32),

                  _buildSection(
                    'Sa jeunesse et la vie associative (2000-2006)',
                    'Témoin des violences qui gangrènent son quartier, du mal-être social qui y règne et du silence des médias, Doosay prend le micro vers la fin des années 90. Ses premiers freestyles à la MJC attirent très vite l\'attention. Il partage la rime avec Halte-S au sein de VERIDIK SECTION. Le groupe enchaîne plusieurs projets avec Episode Répétitif (2002) et Authentique (2004).\n\n'
                    'Pendant plus d\'une dizaine d\'années, Doosay reprendra les ateliers d\'écriture et animera des sessions freestyles avec Halte-S au sein de l\'ADACEM, leur association. Ils permettront ainsi aux jeunes du quartier et de la ville d\'enregistrer leurs maquettes et de monter sur scène lors du Festival Hip-Hop Mouvement, rassemblant pas moins de 2.000 personnes chaque année.',
                  ),
                  const SizedBox(height: 28),

                  _buildSection(
                    'Ses premières armes (2006-2009)',
                    'En 2006, Doosay rejoint le collectif Convoyeurs 2 Flows et sort Première Transaction, une mixtape entièrement auto-produite qui s\'écoulera à 600 exemplaires.\n\n'
                    'En 2007, il sort Mes Thèses et Vous, toujours en duo avec Halte-S. 300 exemplaires de l\'album, enregistré à Pierrefitte, seront vendus de main à main.\n\n'
                    'Grâce au bouche-à-oreille, VERIDIK SECTION gravite autour de la scène rap underground, se produisant sur de petites scènes locales et participant à de nombreux festivals régionaux.',
                  ),
                  const SizedBox(height: 28),

                  _buildSection(
                    'Sa carrière solo (2009-2014)',
                    'Sa plume affûtée met en valeur son flow authentique et spontané. Doosay transpire la sincérité. L\'émotion et l\'énergie qu\'il partage sur scène permettent au public de l\'apprécier dès les premières minutes de show. Il fait ses marques à Paris, Le Havre, Lorient, Dignes-les-Bains…\n\n'
                    'Après une courte expérience solo, où il sortira la mixtape Skelletik Thug (2009), Doosay sortira les Fruits de ma Différence (2010) et Zoo Local (2011) avec Halte-S. VERIDIK SECTION se séparera ensuite.\n\n'
                    'Le MC reçoit plusieurs invitations de Busta Flex pour partager le micro à Skyrock pour la promotion des projets de Flex Stabeu. Doosay participe également à la Flextape 93.8 du Fonky Flex sur le morceau Sans Pitié.',
                  ),
                  const SizedBox(height: 28),

                  _buildSection(
                    'Le Hip-Hop, sa passion (2014-2026)',
                    'Doosay laisse de côté l\'enregistrement et profite de ses apparitions scéniques remarquées pour multiplier les collaborations, notamment avec Busta Flex, Hornet La Frappe, El Deterr ou encore Freko Ding. Il fait de nombreux freestyles et continue de barouder à travers la France.\n\n'
                    'Doosay fait du Hip-Hop un partage et vit cet art comme une véritable passion. « La dignité n\'se monnaye pas / Fais tourner l\'son à chaque renois » « La paix chez soi est une richesse / Les rappeurs qui vendent les mérites du brolique sont des faussaires »\n\n'
                    'En 2019, il fait la rencontre de MR PHIF et de 21gram\' (COMOP). Ensemble, ils montent le collectif Gêne2Génie (G2G) et proposent un premier EP MC de l\'Hiver (2019). Puis Linho, Le Chiller et TA2Z viennent se greffer au collectif. Leur deuxième opus Mêlée Générale (2021) ressortira de cette collaboration. En 2023, Doosay enchaîne les projets. Dans la foulée, il sort Ressources Humaines puis le Gêne2Génie s\'associe à BLVD380 pour les projets G2G et Nuits Blanches.\n\n'
                    'En 2025, Doosay participe aux deux derniers projets d\'Antilpsa : Phonographe 2 et Ce que le vent murmure, confirmant son statut de collaborateur de choix sur la scène rap francophone.',
                  ),
                  const SizedBox(height: 40),

                  // Tracklist EP
                  const Text(
                    'EP — C\'EST LA VIE',
                    style: TextStyle(color: Color(0xFFE8C547), fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  ...kTracks.map(
                    (t) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '${t.id}',
                              style: const TextStyle(color: Color(0xFF555555), fontSize: 13, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                                Text(t.artist, style: const TextStyle(color: Color(0xFF666666), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Politique de confidentialité
                  const Divider(color: Color(0xFF2A2A2A)),
                  const SizedBox(height: 24),
                  const Text(
                    'POLITIQUE DE CONFIDENTIALITÉ',
                    style: TextStyle(color: Color(0xFFE8C547), fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dernière mise à jour : juin 2026\n\n'
                    'L\'application DOOSAY – C\'est la vie est un lecteur audio mobile développé pour écouter les titres de l\'EP "C\'est la vie" de l\'artiste DOOSAY.\n\n'
                    'Collecte de données\n'
                    'Cette application ne collecte, ne stocke et ne transmet aucune donnée personnelle. Aucun compte utilisateur n\'est requis. Aucune information n\'est partagée avec des tiers.\n\n'
                    'Permissions\n'
                    'L\'application utilise uniquement :\n'
                    '• L\'accès audio Bluetooth pour la lecture musicale\n'
                    '• L\'accès à internet pour l\'ouverture des liens vers les réseaux sociaux (Instagram, TikTok, YouTube)\n\n'
                    'Contenus musicaux\n'
                    'Tous les titres musicaux et visuels contenus dans cette application sont la propriété exclusive de DOOSAY (Seydou N\'Diaye). Toute reproduction non autorisée est interdite.\n\n'
                    'Contact\n'
                    'Pour toute question : doosay.original@gmail.com',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 13, height: 1.8),
                  ),
                  const SizedBox(height: 40),

                  // Liens réseaux en bas
                  const Center(
                    child: Text(
                      'SUIVRE DOOSAY',
                      style: TextStyle(color: Color(0xFF555555), fontSize: 11, letterSpacing: 3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        label: 'Instagram',
                        icon: Icons.camera_alt_outlined,
                        color: const Color(0xFFE1306C),
                        onTap: () => _openUrl('https://www.instagram.com/doosay.revenge?igsh=M3g2Z2FmYTk5OWtt'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'TikTok',
                        icon: Icons.music_note_rounded,
                        color: Colors.white,
                        onTap: () => _openUrl('https://www.tiktok.com/@doosay.original'),
                      ),
                      const SizedBox(width: 10),
                      _SocialButton(
                        label: 'YouTube',
                        icon: Icons.play_circle_outline_rounded,
                        color: const Color(0xFFFF0000),
                        onTap: () => _openUrl('https://www.youtube.com/@doosaydelepok'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFFE8C547), fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        Text(body, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 15, height: 1.8)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF333333)),
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF1E1E1E),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
