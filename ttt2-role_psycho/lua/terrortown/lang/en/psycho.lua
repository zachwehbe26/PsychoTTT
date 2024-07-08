local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[PSYCHO.name] = "Psycho"
L["info_popup_" .. PSYCHO.name] = [[You are the Psycho! Transform and Untransform into the psycho with your gadget.]]
L["body_found_" .. PSYCHO.abbr] = "They were a Psycho."
L["search_role_" .. PSYCHO.abbr] = "This person was a Psycho!"
L["target_" .. PSYCHO.name] = "Psycho"
L["ttt2_desc_" .. PSYCHO.name] = [[The Psycho uses his gadget to transform and get buffs such as increased movement speed, and a radar.]]
L["credit_" .. PSYCHO.abbr .. "_all"] = "Psycho, you have been awarded {num} equipment credit(s) for your performance."

-- STATUS LANGUAGE STRINGS
L["psycho_gadget"] = "Psycho Transform"
L["label_psy_transform_delay"] = "The delay between transforming: "
L["label_psy_transform_dmg_multi"] = "The damage multiplier when transformed: "
L["label_psy_transform_spd_multi"] = "The speed multiplier when transformed"
L["status_psy_transform_cooldown"] = "You have transformed recently and the gadget is on cooldown"
L["status_psy_dmg_bonus"] = "You have transformed and received a damage up!"
L["item_psycho_speedrun_title"] = "You have transformed into the psycho!"
L["item_psycho_speedrun_desc"] = "Use your buffs to aid you in battle! Be careful, other people see you differently."