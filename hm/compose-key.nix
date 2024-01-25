{ config, lib, pkgs, ... }:

{
  options = {
    sys.compose-key.enableCustom = lib.mkOption {
      description = "Whether to enable custom compose key sequencces.";
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
    };
  };
  config = lib.mkIf config.sys.compose-key.enableCustom {
    home.file.".XCompose".text = ''
      # Include defaults
      include "%L"

      # see Compose(5) and <https://blogs.s-osg.org/custom-compose-keys-on-ubuntu/>
      # the things in angle brackets are keysyms, a list of them can be found at
      # <http://wiki.linuxquestions.org/wiki/List_of_Keysyms_Recognised_by_Xmodmap>
      # standard definitions are usually in /usr/share/X11/locale/en_US.UTF-8/Compose
      # Format:
      # <Multi_key> <keyname> <otherkeyname> : "character(s)" U1234 # Comment

      ## Fun Unicode stuff
      <Multi_key> <z> <w> <n> <j> : "‌" U200C # ZERO WIDTH NON-JOINER
      <Multi_key> <z> <w> <j> : "‍" U200D # ZERO WIDTH JOINER
      <Multi_key> <space> <minus> : " " U2009 # THIN SPACE
      <Multi_key> <space> <0> : " " U202F # NARROW NO-BREAK SPACE
      <Multi_key> <space> <bar> : " " U200A # HAIR SPACE

      # Emoji
      <Multi_key> <plus> <1> : "👍" U1F44D # THUMBS UP SIGN
      <Multi_key> <minus> <1> : "👎" U1F44E # THUMBS DOWN SIGN
      <Multi_key> <f> <u> <g> : "🙃" U1F643 # UPSIDE-DOWN FACE
      <Multi_key> <t> <a> <d> <a> : "🎉" U1F389 # PARTY POPPER
      <Multi_key> <t> <r> : "⚧" U26A7 # MALE WITH STROKE AND MALE AND FEMALE SIGN

      ## Misc symbols
      <Multi_key> <at> <slash> : "✓" U2713 # CHECK MARK
      <Multi_key> <n> <b> : "※" U203B # REFERENCE MARK

      ## Music
      <Multi_key> <numbersign> <F> : "𝆑" U1D191 # MUSICAL SYMBOL FORTE
      <Multi_key> <numbersign> <p> : "𝆏" U1D18F # MUSICAL SYMBOL PIANO
      <Multi_key> <numbersign> <m> : "𝆐" U1D190 # MUSICAL SYMBOL MEZZO
      <Multi_key> <numbersign> <n> : "♮" U266E # MUSIC NATURAL SIGN
      # sharp is on <multi>##, flat is on <multi>#b

      ## Maths
      <Multi_key> <3> <equal> : "≡" U2261 # IDENTICAL TO
      <Multi_key> <equal> <3> : "≡" U2261 # IDENTICAL TO
      <Multi_key> <4> <equal> : "≣" U2263 # STRICTLY EQUIVALENT TO
      <Multi_key> <equal> <4> : "≣" U2263 # STRICTLY EQUIVALENT TO
      <Multi_key> <exclam> <3> <equal> : "≢" U2262 # NOT IDENTICAL TO
      <Multi_key> <exclam> <equal> <3> : "≢" U2262 # NOT IDENTICAL TO
      <Multi_key> <p> <i> : "π" U03C0 # GREEK SMALL LETTER PI
      <Multi_key> <asciitilde> <equal> : "≈" U2248 # ALMOST EQUAL TO
      <Multi_key> <equal> <asciitilde> : "≈" U2248 # ALMOST EQUAL TO
      <Multi_key> <bar> <minus> <greater> : "↦" U21A6 # RIGHTWARDS ARROW FROM BAR
      # U21A4 LEFTWARDS ARROW FROM BAR conflicts with <less> <minus> for predefined U2190, and is less useful anyway
      <Multi_key> <i> <n> <t> : "∫" U222B # INTEGRAL
      <Multi_key> <p> <r> <o> <p> : "∝" U221D # PROPORTIONAL TO
      # <Multi_key> <C> <C> : "ℂ" U2102 # DOUBLE-STRUCK CAPITAL C
      # <Multi_key> <N> <N> : "ℕ" U2115 # DOUBLE-STRUCK CAPITAL N
      # <Multi_key> <Q> <Q> : "ℚ" U211A # DOUBLE-STRUCK CAPITAL Q
      # <Multi_key> <Z> <Z> : "ℤ" U2124 # DOUBLE-STRUCK CAPITAL Z
      <Multi_key> <apostrophe> <1> : "′" U2032 # PRIME
      <Multi_key> <1> <apostrophe> : "′" U2032 # PRIME
      <Multi_key> <apostrophe> <2> : "″" U2033 # DOUBLE PRIME
      <Multi_key> <2> <apostrophe> : "″" U2033 # DOUBLE PRIME
      <Multi_key> <apostrophe> <3> : "‴" U2034 # TRIPLE PRIME
      <Multi_key> <3> <apostrophe> : "‴" U2034 # TRIPLE PRIME
      <Multi_key> <apostrophe> <4> : "⁗" U2057 # QUADRUPLE PRIME
      <Multi_key> <4> <apostrophe> : "⁗" U2057 # QUADRUPLE PRIME
      <Multi_key> <0> <0> : "∘" U2218 # RING OPERATOR
      <Multi_key> <minus> <bar> : "⊣" U22A3 # LEFT TACK
      <Multi_key> <bar> <minus> : "⊢" U22A2 # RIGHT TACK
      <Multi_key> <t> <e> <e> : "⊤" U22A4 # DOWN TACK
      <Multi_key> <T> <e> <e> : "⊥" U22A5 # UP TACK

      # double-struck letters
      <Multi_key> <A> <A> : "𝔸" U1D538
      <Multi_key> <B> <B> : "𝔹" U1D539
      <Multi_key> <C> <C> : "ℂ" U2102
      <Multi_key> <D> <D> : "𝔻" U1D53B
      <Multi_key> <E> <E> : "𝔼" U1D53C
      <Multi_key> <F> <F> : "𝔽" U1D53D
      <Multi_key> <G> <G> : "𝔾" U1D53E
      <Multi_key> <H> <H> : "ℍ" U210D
      <Multi_key> <I> <I> : "𝕀" U1D540
      <Multi_key> <J> <J> : "𝕁" U1D541
      <Multi_key> <K> <K> : "𝕂" U1D542
      <Multi_key> <L> <L> : "𝕃" U1D543
      <Multi_key> <M> <M> : "𝕄" U1D544
      <Multi_key> <N> <N> : "ℕ" U2115
      <Multi_key> <O> <O> : "𝕆" U1D546
      <Multi_key> <P> <P> : "ℙ" U2119
      <Multi_key> <Q> <Q> : "ℚ" U211A
      <Multi_key> <R> <R> : "ℝ" U211D
      <Multi_key> <S> <S> : "𝕊" U1D54A
      <Multi_key> <T> <T> : "𝕋" U1D54B
      <Multi_key> <U> <U> : "𝕌" U1D54C
      <Multi_key> <V> <V> : "𝕍" U1D54D
      <Multi_key> <W> <W> : "𝕎" U1D54E
      <Multi_key> <X> <X> : "𝕏" U1D54F
      <Multi_key> <Y> <Y> : "𝕐" U1D550
      <Multi_key> <Z> <Z> : "ℤ" U2124

      # Logic
      <Multi_key> <l> <a> <n> <d> : "∧" U2227 # LOGICAL AND
      <Multi_key> <l> <o> <r> : "∨" U2228 # LOGICAL OR
      <Multi_key> <l> <n> <o> <t> : "¬" U00AC # NOT SIGN
      <Multi_key> <l> <n> <a> <n> <d> : "↑" U2191 # UPWARDS ARROW
      <Multi_key> <l> <n> <o> <r> : "↓" U2193 # DOWNWARDS ARROW
      <Multi_key> <l> <x> <o> <r> <plus> : "⊕" U2295 # CIRCLED PLUS
      <Multi_key> <l> <x> <o> <r> <v> : "⊻" U22BB # XOR
      <Multi_key> <l> <t> <o> <p> : "⊤" U22A4 # DOWN TACK
      <Multi_key> <l> <b> <o> <t> : "⊥" U22A5 # UP TACK
      <Multi_key> <l> <a> <l> <l> : "∀" U2200 # FOR ALL
      <Multi_key> <l> <a> <n> <y> : "∃" U2203 # THERE EXISTS
      <Multi_key> <l> <exclam> <a> <n> <y> : "∄" U2204 # THERE DOES NOT EXIST
      <Multi_key> <l> <i> <s> : "≡" U2261 # IDENTICAL TO
      <Multi_key> <l> <exclam> <i> <s> : "≢" U2262 # NOT IDENTICAL TO
      <Multi_key> <i> <f> <f> : "⇔" U21D4 # LEFT RIGHT DOUBLE ARROW

      # Sets
      <Multi_key> <m> <s> <u> <b> : "⊆" U2286 # SUBSET OF OR EQUAL TO
      <Multi_key> <m> <s> <s> <u> <b> : "⊂" U2282 # SUBSET OF
      <Multi_key> <m> <s> <u> <p> : "⊇" U2287 # SUPERSET OF OR EQUAL TO
      <Multi_key> <m> <s> <s> <u> <p> : "⊃" U2283 # SUPERSET OF
      <Multi_key> <m> <c> <a> <p> : "∩" U2229 # INTERSECTION
      <Multi_key> <m> <c> <u> <p> : "∪" U222A # UNION
      <Multi_key> <m> <i> <n> : "∈" U2208 # ELEMENT OF
      <Multi_key> <m> <exclam> <i> <n> : "∉" U2209 # NOT AN ELEMENT OF
      <Multi_key> <m> <o> <slash> : "∅" U2205 # EMPTY SET
      <Multi_key> <m> <slash> <o> : "∅" U2205 # EMPTY SET

      ## Greek ("g", then as many letters as necessary to uniquely identify the letter)
      <Multi_key> <g> <A> : "Α" # alpha
      <Multi_key> <g> <a> : "α"
      <Multi_key> <g> <B> : "Β" # beta
      <Multi_key> <g> <b> : "β"
      <Multi_key> <g> <G> : "Γ" # gamma
      <Multi_key> <g> <g> : "γ"
      <Multi_key> <g> <D> : "Δ" # delta
      <Multi_key> <g> <d> : "δ"
      <Multi_key> <g> <E> <p> : "Ε" # epsilon
      <Multi_key> <g> <e> <p> : "ε"
      <Multi_key> <g> <Z> : "Ζ" # zeta
      <Multi_key> <g> <z> : "ζ"
      <Multi_key> <g> <E> <t> : "Η" # eta
      <Multi_key> <g> <e> <t> : "η"
      <Multi_key> <g> <T> <h> : "Θ" # theta
      <Multi_key> <g> <t> <h> : "θ"
      <Multi_key> <g> <I> : "Ι" # iota
      <Multi_key> <g> <i> : "ι"
      <Multi_key> <g> <K> : "Κ" # kappa
      <Multi_key> <g> <k> : "κ"
      <Multi_key> <g> <L> : "Λ" # lambda
      <Multi_key> <g> <l> : "λ"
      <Multi_key> <g> <M> : "Μ" # mu
      <Multi_key> <g> <m> : "μ"
      <Multi_key> <g> <N> : "Ν" # nu
      <Multi_key> <g> <n> : "ν"
      <Multi_key> <g> <X> : "Ξ" # xi
      <Multi_key> <g> <x> : "ξ"
      <Multi_key> <g> <O> <m> <i> : "Ο" # omicron
      <Multi_key> <g> <o> <m> <i> : "ο"
      <Multi_key> <g> <P> <i> : "Π" # pi
      <Multi_key> <g> <p> <i> : "π"
      <Multi_key> <g> <R> : "Ρ" # rho
      <Multi_key> <g> <r> : "ρ"
      <Multi_key> <g> <S> : "Σ" # sigma
      <Multi_key> <g> <s> : "σ"
      <Multi_key> <g> <T> <a> : "Τ" # tau
      <Multi_key> <g> <t> <a> : "τ"
      <Multi_key> <g> <U> : "Υ" # upsilon
      <Multi_key> <g> <u> : "υ"
      <Multi_key> <g> <P> <h> : "Φ" # phi
      <Multi_key> <g> <p> <h> : "φ"
      <Multi_key> <g> <C> : "Χ" # chi
      <Multi_key> <g> <c> : "χ"
      <Multi_key> <g> <P> <s> : "Ψ" # psi
      <Multi_key> <g> <p> <s> : "ψ"
      <Multi_key> <g> <O> <m> <e> : "Ω" # omega
      <Multi_key> <g> <o> <m> <e> : "ω"
    '';
  };
}
