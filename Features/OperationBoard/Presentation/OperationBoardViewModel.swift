import Foundation
import PickleBallMatchingCore

@MainActor
final class OperationBoardViewModel: ObservableObject {
    @Published var session: Session
    @Published var newParticipantName = ""
    @Published private(set) var errorMessage: String?

    private let generateNextRoundUseCase: GenerateNextRoundUseCase
    private let sessionRepository: (any SessionRepository)?

    init(
        session: Session? = nil,
        generateNextRoundUseCase: GenerateNextRoundUseCase = GenerateNextRoundUseCase(),
        sessionRepository: (any SessionRepository)? = nil
    ) {
        self.generateNextRoundUseCase = generateNextRoundUseCase
        self.sessionRepository = sessionRepository

        if let session {
            self.session = session
        } else {
            do {
                self.session = try sessionRepository?.loadLatestSession() ?? .defaultSession()
            } catch {
                self.session = .defaultSession()
                errorMessage = "保存済みセッションを読み込めませんでした。新規セッションで開始します。"
            }
        }
    }

    var currentRound: Round? {
        session.currentRound
    }

    var canGenerateRound: Bool {
        session.participants.count(where: { $0.status.isAvailableForRound }) >= 4
    }

    func addParticipant() {
        let name = newParticipantName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            return
        }

        session.participants.append(
            Participant(
                displayName: name,
                skillLevel: defaultSkillLevel(for: session.participants.count)
            )
        )
        newParticipantName = ""
        session.updatedAt = Date()
        errorMessage = nil
        saveSession()
    }

    func removeParticipants(at offsets: IndexSet) {
        session.participants.remove(atOffsets: offsets)
        session.updatedAt = Date()
        saveSession()
    }

    func updateCourtCount(_ courtCount: Int) {
        session.courtCount = max(1, courtCount)
        session.updatedAt = Date()
        saveSession()
    }

    func generateNextRound() {
        do {
            session = try generateNextRoundUseCase.execute(session: session)
            errorMessage = nil
            saveSession()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func defaultSkillLevel(for index: Int) -> SkillLevel {
        SkillLevel(rawValue: (index % SkillLevel.allCases.count) + 1) ?? .beginner
    }

    private func saveSession() {
        do {
            try sessionRepository?.save(session)
        } catch {
            errorMessage = "セッションを保存できませんでした。端末の空き容量を確認してください。"
        }
    }
}

extension Session {
    static func defaultSession() -> Session {
        Session(
            name: "今日のピックルボール",
            courtCount: 2,
            roundDurationMinutes: 12,
            mode: .normalPractice,
            participants: [
                Participant(displayName: "佐藤", skillLevel: .beginner),
                Participant(displayName: "鈴木", skillLevel: .novice),
                Participant(displayName: "高橋", skillLevel: .intermediate),
                Participant(displayName: "田中", skillLevel: .advanced),
                Participant(displayName: "伊藤", skillLevel: .beginner),
                Participant(displayName: "渡辺", skillLevel: .novice),
                Participant(displayName: "山本", skillLevel: .intermediate),
                Participant(displayName: "中村", skillLevel: .advanced),
                Participant(displayName: "小林", skillLevel: .beginner),
                Participant(displayName: "加藤", skillLevel: .novice)
            ]
        )
    }
}
