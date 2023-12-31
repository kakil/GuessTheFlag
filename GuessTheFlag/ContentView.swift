//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kitwana Akil on 7/12/23.
//

import SwiftUI

struct FlagImage: View {
    
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingAlert = false
    @State private var selectedAnswer: Int = 1
    @State private var questionCount: Int = 0
    @State private var showingEndGame = false
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200 , endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            //flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle.lowercased() == "correct" {
                Text("Your score is \(score)")
            } else {
                Text("Wrong!  That's the flag of \(countries[selectedAnswer])")
            }
            
        }
        .alert(scoreTitle, isPresented: $showingEndGame) {
            Button("New Game", action: resetGame)
        } message: {
            Text("Your Final Score Is: \(score)")
        }
        
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }
        questionCount += 1
        selectedAnswer = number
        showingScore = true
    }
    
    func askQuestion() {
        
        if questionCount == 8 {
            endGame()
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        questionCount = 0
        score = 0
        selectedAnswer = 1
        showingScore = false
        
        askQuestion()
        
    }
    
    func endGame() {
        scoreTitle = "Game Over"
        showingEndGame = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
