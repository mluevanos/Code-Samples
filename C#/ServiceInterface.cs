using Sabio.Models;
using Sabio.Models.Domain;
using Sabio.Models.Requests.Notes;
using System.Collections.Generic;

namespace Sabio.Services
{
    public interface INoteService

    {
        Paged<Note> SearchNotesBySeeker(int userId, string searchQuery, int pageIndex, int pageSize);
        Paged<Note> SearchNotesByProvider(int userId, string searchQuery, int pageIndex, int pageSize);
        Paged<Note> GetNotesBySeekerId(int userId, int pageIndex, int pageSize);
        Note Get(int id);
        Paged<Note> GetNotesCreatedBy(int id, int pageIndex, int pageSize);
        List<BaseUserProfile> GetAllSeekerNames(int providerId);
        int Add(AddNoteRequest model, int createdById);
        void Update(UpdateNoteRequest model, int createdById);
        void Delete(int id);
        
    }
}
