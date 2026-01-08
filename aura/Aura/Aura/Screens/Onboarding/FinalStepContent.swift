//
//  FinalStepContent.swift
//  Aura
//
//  Created by Ezgi Özkan on 7.01.2026.
//

import SwiftUI

struct FinalStepContent: View {
    @Binding var selectedSex: String?
    @Binding var selectedAge: String?
    @Binding var selectedIntention: String?

    var body: some View {
        VStack(spacing: 32) {

            VStack(spacing: 12) {
                Text(LocalizedStringKey("final_step_sex_title")).foregroundStyle(.white.opacity(0.7))
                HStack {
                    OptionChip(titleKey: LocalizedStringKey("final_step_sex_male"), isSelected: selectedSex == "male") {
                        selectedSex = "male"
                    }
                    OptionChip(titleKey: LocalizedStringKey("final_step_sex_female"), isSelected: selectedSex == "female") {
                        selectedSex = "female"
                    }
                    OptionChip(titleKey: LocalizedStringKey("final_step_sex_non_binary"), isSelected: selectedSex == "non_binary") {
                        selectedSex = "non_binary"
                    }
                }
            }

            VStack(spacing: 12) {
                Text(LocalizedStringKey("final_step_age_title")).foregroundStyle(.white.opacity(0.7))
                HStack {
                    OptionChip(titleKey: LocalizedStringKey("final_step_age_13_17"), isSelected: selectedAge == "13-17") { selectedAge = "13-17" }
                    OptionChip(titleKey: LocalizedStringKey("final_step_age_18_24"), isSelected: selectedAge == "18-24") { selectedAge = "18-24" }
                    OptionChip(titleKey: LocalizedStringKey("final_step_age_25_34"), isSelected: selectedAge == "25-34") { selectedAge = "25-34" }
                }
                HStack {
                    OptionChip(titleKey: LocalizedStringKey("final_step_age_35_44"), isSelected: selectedAge == "35-44") { selectedAge = "35-44" }
                    OptionChip(titleKey: LocalizedStringKey("final_step_age_45_plus"), isSelected: selectedAge == "45+") { selectedAge = "45+" }
                }
            }

            VStack(spacing: 12) {
                Text(LocalizedStringKey("final_step_intention_title")).foregroundStyle(.white.opacity(0.7))
                HStack {
                    OptionChip(titleKey: LocalizedStringKey("final_step_intention_relationship"), isSelected: selectedIntention == "relationship") {
                        selectedIntention = "relationship"
                    }
                    OptionChip(titleKey: LocalizedStringKey("final_step_intention_casual"), isSelected: selectedIntention == "casual") {
                        selectedIntention = "casual"
                    }
                    OptionChip(titleKey: LocalizedStringKey("final_step_intention_fun"), isSelected: selectedIntention == "fun") {
                        selectedIntention = "fun"
                    }
                }
            }
        }
        .padding(.top, 24)
    }
}
