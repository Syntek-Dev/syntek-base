# Failure Modes — AI Coding Dictionary

**Part of:** [`AI-DICTIONARY.md`](../AI-DICTIONARY.md) · **Language:** British English (en_GB) · **Timezone:** {{TIMEZONE}}

These are the characteristic ways an AI coding agent goes wrong — and the mechanics underneath them. The first four cover what the model believes and where those beliefs come from; the last five trace how a growing session quietly erodes the model's grip on what it already knows. Naming the exact failure mode matters because the fixes pull in opposite directions: some problems are cured by adding context, others only by taking it away.

---

## Sycophancy

**Sycophancy** is confidently agreeable model output — the model bending to your framing rather than reasoning independently. It arises from _training_, which shaped the model to favour answers humans liked, and humans like agreement more than being told they are wrong.

**Why it matters:** It caves under pushback, praises broken plans, and skews a review toward whoever it thinks wrote the code. Phrase prompts neutrally ("review this code", not "is this code good?") and apply the diagnostic test — would the model have said this without your steer? If only your tone changed, it is sycophancy, not analysis.

## Hallucination

**Hallucination** is confidently-wrong model output, in two flavours: _factuality_ (invented facts — a method or API that does not exist, a fake citation) and _faithfulness_ (drift from the _contextual knowledge_, instructions, or prior reasoning already loaded). _Next-token prediction_ produces fluent output whether or not the underlying fact is real, so a fabricated method arrives in the same assured register as a correct one.

**Why it matters:** The fix for one flavour makes the other worse. Factuality means missing knowledge — add context. Faithfulness means the knowledge is present but losing the competition for attention — _clear_ or _compact_ instead. Check whether the correct information was already in context before deciding which problem you have.

## Parametric knowledge

**Parametric knowledge** is what the model "knows" from _training_, stored in its _parameters_ and frozen at training time — the model cannot see or update it. It is dense and reliable on common topics and blurry on rare ones, because billions of facts are squeezed into a fixed number of parameters. Counterpart to _contextual knowledge_.

**Why it matters:** Reproducing a well-represented fact and guessing at a rare one are the same process to the model, so fabrication arrives with the same fluency as truth. Gaps — a topic too rare, or a library past the _knowledge cutoff_ — cannot be added to the parameters, only supplied as contextual knowledge.

## Knowledge cutoff

The **knowledge cutoff** is the date past which a model has no _parametric knowledge_; each model release ships with its own. The model does not know its knowledge has an edge — asked about something later, it extrapolates from the nearest thing it does know rather than refusing.

**Why it matters:** Post-cutoff libraries and APIs are quiet fabrication traps — the extrapolated code looks plausible, often compiles, and fails only on the parts that changed. Load the current changelog, point at the installed version's type definitions, or have the agent read the docs: anything in context outranks nothing in the parameters.

## Contextual knowledge

**Contextual knowledge** is facts the _agent_ can read directly from the _context_ right now — the task, files it has read in, _tool results_, `AGENTS.md` loaded at _session_ start. Counterpart to _parametric knowledge_: parametric is recalled from the parameters, contextual is read from the window, and hallucinations are far rarer when the answer is right in front of the model.

**Why it matters:** It is the only knowledge you control, and it usually wins conflicts with stale parametric memory. But it costs _tokens_ and competes for the _attention budget_, so loading more is not automatically better — the aim is the relevant facts in the window, not all the facts.

## Attention relationship

An **attention relationship** is the pairing between two _tokens_ — meaningful pairs (a `getUser()` call and its `function getUser` definition, "her" with "Sarah") influence each other more than unrelated ones. A context of N tokens holds on the order of N² of these, each recomputed fresh on every _model provider request_.

**Why it matters:** These pairings are where the model's apparent understanding lives, yet only a handful matter for any task while the total pool grows quadratically. The signal you care about gets rarer as context grows — one in a million at 1,000 tokens, one in ten billion at 100,000 — which is the arithmetic beneath _attention budget_ and _attention degradation_.

## Attention budget

The **attention budget** is the finite amount of influence each _token_ has to distribute across the rest of the _context_. Heavy influence on one _attention relationship_ leaves less for others; the budget is per-token and does not grow when the context does.

**Why it matters:** Your instruction stays at fixed volume, but a growing _context window_ makes the room louder around it, so the signal-to-noise ratio drops — an instruction that was loudest at 10k tokens is background hum at 150k. The symptom reads as disobedience; the cause is everything else competing. Keep the window small and _clear_ when accumulated context stops paying its way.

## Attention degradation

**Attention degradation** is what happens as a _session_ grows: each token's _attention budget_ spreads across more competitors, so the signal on any one meaningful _attention relationship_ shrinks while noise from irrelevant _context_ crowds in. Same model, same _parameters_ — just more mouths to feed from the same plate.

**Why it matters:** It presents as the model getting worse mid-session — slipping constraints, re-asking things it was told, ignoring a file it read earlier — and it is gradual, so it is hard to catch from inside. Recover by removing context (_clear_ and reload, _compact_, or _hand off_), never by re-pasting, which only adds another competitor to a crowded window.

## Smart zone

Early in a _session_ the agent is in a **smart zone** — sharp, focused, good recall. As the session grows it drifts into a "dumb zone": sloppier, more forgetful, more faithfulness _hallucinations_. It is the felt effect of _attention degradation_; on frontier models the dumb zone commonly begins around 125K–150K _tokens_, though this is debated.

**Why it matters:** The zones do not track the _context window_ limit — quality falls off long before the window fills — so plan around the smart zone as a budget, not the window. Do one task per session, and when a task outgrows a single smart zone, split it: _hand off_ or _compact_ at a natural boundary rather than pushing through and re-explaining.

---

_Part of the [AI Coding Dictionary](../AI-DICTIONARY.md) · how-to/docs/ documentation family._
